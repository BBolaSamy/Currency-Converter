import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/connectivity_status.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/stale_policy.dart';
import '../../domain/entities/latest_rate_quote.dart';
import '../../domain/entities/rate_point.dart';
import '../../domain/repositories/rates_repository.dart';
import '../datasources/rates_local_data_source.dart';
import '../datasources/rates_remote_data_source.dart';
import '../../../../core/persistence/app_database.dart' as db;

@LazySingleton(as: RatesRepository)
class RatesRepositoryImpl implements RatesRepository {
  RatesRepositoryImpl(
    this._remote,
    this._local,
    this._connectivity,
    this._stalePolicy,
  );

  final RatesRemoteDataSource _remote;
  final RatesLocalDataSource _local;
  final ConnectivityService _connectivity;
  final StalePolicy _stalePolicy;

  static const _maxAge = Duration(hours: 12);
  static const _snapshotBase = 'USD';

  @override
  Future<Result<LatestRateQuote>> getLatestRate({
    required String from,
    required String to,
    bool forceRefresh = false,
  }) async {
    try {
      final f = from.toUpperCase();
      final t = to.toUpperCase();

      final cachedRate = await _getCrossRateFromCache(from: f, to: t);
      final fetchedAt = await _local.getLatestFetchedAtUtc(
        from: _snapshotBase,
        to: _snapshotBase,
      );
      final stale = fetchedAt == null ||
          _stalePolicy.isStale(fetchedAtUtc: fetchedAt, maxAge: _maxAge);

      final status = await _connectivity.getCurrentStatus();
      final canFetch = status == ConnectivityStatus.online;

      if (forceRefresh && canFetch) {
        await _refreshSnapshotBaseInForeground();
        final rate = await _getCrossRateFromCache(from: f, to: t);
        if (rate == null) return const FailureResult(CacheFailure());
        return Success(
          LatestRateQuote(
            from: f,
            to: t,
            rate: rate,
            fetchedAtUtc: DateTime.now().toUtc(),
          ),
        );
      }

      // Offline-first: if we have cache, return it even if stale.
      if (cachedRate != null) {
        // Background refresh if stale and online (don't block the UI).
        if (stale && canFetch) {
          unawaited(_refreshSnapshotBaseInBackground());
        }
        return Success(
          LatestRateQuote(
            from: f,
            to: t,
            rate: cachedRate,
            fetchedAtUtc: fetchedAt ?? DateTime.now().toUtc(),
          ),
        );
      }

      // No cache: fetch if possible.
      if (!canFetch) return const FailureResult(CacheFailure());

      await _refreshSnapshotBaseInForeground();
      final rate = await _getCrossRateFromCache(from: f, to: t);
      if (rate == null) return const FailureResult(CacheFailure());
      return Success(
        LatestRateQuote(
          from: f,
          to: t,
          rate: rate,
          fetchedAtUtc: DateTime.now().toUtc(),
        ),
      );
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }

  Future<void> _refreshSnapshotBaseInBackground() async {
    try {
      await _refreshSnapshotBaseInForeground();
    } catch (_) {
      // swallow
    }
  }

  @override
  Future<Result<List<RatePoint>>> getLast7Days({
    required String from,
    required String to,
    bool forceRefresh = false,
  }) async {
    try {
      final f = from.toUpperCase();
      final t = to.toUpperCase();
      final now = DateTime.now().toUtc();
      final end = DateTime.utc(now.year, now.month, now.day);
      final start = end.subtract(const Duration(days: 6));
      final startStr = _fmtDate(start);
      final endStr = _fmtDate(end);

      final usdToFrom = await _local.getHistorical(from: _snapshotBase, to: f);
      final usdToTo = await _local.getHistorical(from: _snapshotBase, to: t);
      final lastFetchedAt = await _local.getHistoricalFetchedAtUtc(
        from: _snapshotBase,
        to: _snapshotBase,
      );
      final stale =
          lastFetchedAt == null ||
          _stalePolicy.isStale(fetchedAtUtc: lastFetchedAt, maxAge: _maxAge);

      final status = await _connectivity.getCurrentStatus();
      final canFetch = status == ConnectivityStatus.online;

      final cachedPoints = _buildCrossHistory(
        from: f,
        to: t,
        startDate: startStr,
        endDate: endStr,
        usdToFrom: usdToFrom,
        usdToTo: usdToTo,
      );

      if (!forceRefresh && cachedPoints.isNotEmpty) {
        if (stale && canFetch) {
          unawaited(_refreshSnapshotBaseInBackground());
        }
        return Success(cachedPoints);
      }

      if (forceRefresh && canFetch) {
        await _refreshSnapshotBaseInForeground();
        final refreshedFrom = await _local.getHistorical(from: _snapshotBase, to: f);
        final refreshedTo = await _local.getHistorical(from: _snapshotBase, to: t);
        final points = _buildCrossHistory(
          from: f,
          to: t,
          startDate: startStr,
          endDate: endStr,
          usdToFrom: refreshedFrom,
          usdToTo: refreshedTo,
        );
        if (points.isEmpty) return const FailureResult(CacheFailure());
        return Success(points);
      }

      if (!canFetch) {
        if (cachedPoints.isNotEmpty) return Success(cachedPoints);
        return const FailureResult(CacheFailure());
      }

      await _refreshSnapshotBaseInForeground();
      final refreshedFrom = await _local.getHistorical(from: _snapshotBase, to: f);
      final refreshedTo = await _local.getHistorical(from: _snapshotBase, to: t);
      final points = _buildCrossHistory(
        from: f,
        to: t,
        startDate: startStr,
        endDate: endStr,
        usdToFrom: refreshedFrom,
        usdToTo: refreshedTo,
      );
      if (points.isEmpty) return const FailureResult(CacheFailure());
      return Success(points);
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }

  Future<void> _refreshSnapshotBaseInForeground() async {
    final snapshot = await _remote.fetchLatestForBase(base: _snapshotBase);
    final fetchedAtUtc = DateTime.fromMillisecondsSinceEpoch(
      snapshot.timeLastUpdateUnix * 1000,
      isUtc: true,
    );

    // Store a "marker" row for base->base so we can read fetchedAt as a global timestamp.
    await _local.upsertLatest(
      from: _snapshotBase,
      to: _snapshotBase,
      rate: 1.0,
      fetchedAtUtc: fetchedAtUtc,
    );

    // Store USD->X latests and also today's historical snapshot.
    final today = _fmtDate(DateTime.now().toUtc());
    await _local.upsertLatestMany(
      from: _snapshotBase,
      rates: snapshot.conversionRates,
      fetchedAtUtc: fetchedAtUtc,
    );
    await _local.upsertHistoricalDailySnapshot(
      from: _snapshotBase,
      date: today,
      rates: snapshot.conversionRates,
      fetchedAtUtc: fetchedAtUtc,
    );
  }

  String _fmtDate(DateTime dtUtc) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dtUtc.year}-${two(dtUtc.month)}-${two(dtUtc.day)}';
  }

  Future<double?> _getCrossRateFromCache({
    required String from,
    required String to,
  }) async {
    if (from == to) return 1.0;
    if (from == _snapshotBase) {
      final usdToTo = await _local.getLatest(from: _snapshotBase, to: to);
      return usdToTo?.rate;
    }
    if (to == _snapshotBase) {
      final usdToFrom = await _local.getLatest(from: _snapshotBase, to: from);
      final r = usdToFrom?.rate;
      if (r == null || r == 0) return null;
      return 1.0 / r;
    }

    final usdToFrom = await _local.getLatest(from: _snapshotBase, to: from);
    final usdToTo = await _local.getLatest(from: _snapshotBase, to: to);
    final a = usdToFrom?.rate;
    final b = usdToTo?.rate;
    if (a == null || b == null || a == 0) return null;
    return b / a;
  }

  List<RatePoint> _buildCrossHistory({
    required String from,
    required String to,
    required String startDate,
    required String endDate,
    required List<db.HistoricalRate> usdToFrom,
    required List<db.HistoricalRate> usdToTo,
  }) {
    final mapFrom = {for (final r in usdToFrom) r.date: r.rate};
    final mapTo = {for (final r in usdToTo) r.date: r.rate};

    final points = <RatePoint>[];
    for (final d in mapTo.keys) {
      if (d.compareTo(startDate) < 0 || d.compareTo(endDate) > 0) continue;
      final a = mapFrom[d];
      final b = mapTo[d];
      if (a == null || b == null || a == 0) continue;
      points.add(RatePoint(date: d, rate: b / a));
    }
    points.sort((x, y) => x.date.compareTo(y.date));
    return points;
  }
}
