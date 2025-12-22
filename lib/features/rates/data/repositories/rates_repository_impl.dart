import 'dart:async';

import 'dart:math';

import 'package:dio/dio.dart';
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
import '../models/apilayer_latest_response.dart';

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

  @override
  Future<Result<LatestRateQuote>> getLatestRate({
    required String from,
    required String to,
    bool forceRefresh = false,
  }) async {
    try {
      final f = from.toUpperCase();
      final t = to.toUpperCase();

      final cached = await _local.getLatest(from: f, to: t);
      final fetchedAt = cached?.fetchedAtUtc;
      final stale =
          fetchedAt == null ||
          _stalePolicy.isStale(fetchedAtUtc: fetchedAt, maxAge: _maxAge);

      final status = await _connectivity.getCurrentStatus();
      final canFetch = status == ConnectivityStatus.online;

      if (forceRefresh && canFetch) {
        final quote = await _fetchLatestQuote(from: f, to: t);
        await _local.upsertLatest(
          from: f,
          to: t,
          rate: quote.rate,
          fetchedAtUtc: quote.fetchedAtUtc,
        );
        return Success(quote);
      }

      // Offline-first: if we have cache, return it even if stale.
      if (cached != null) {
        // Background refresh if stale and online (don't block the UI).
        if (stale && canFetch) {
          unawaited(_refreshLatestInBackground(from: f, to: t));
        }
        return Success(
          LatestRateQuote(
            from: f,
            to: t,
            rate: cached.rate,
            fetchedAtUtc: fetchedAt ?? DateTime.now().toUtc(),
          ),
        );
      }

      // No cache: fetch if possible.
      if (!canFetch) return const FailureResult(CacheFailure());

      final quote = await _fetchLatestQuote(from: f, to: t);
      await _local.upsertLatest(
        from: f,
        to: t,
        rate: quote.rate,
        fetchedAtUtc: quote.fetchedAtUtc,
      );
      return Success(quote);
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }

  Future<void> _refreshLatestInBackground({
    required String from,
    required String to,
  }) async {
    try {
      final quote = await _fetchLatestQuote(from: from, to: to);
      await _local.upsertLatest(
        from: from,
        to: to,
        rate: quote.rate,
        fetchedAtUtc: quote.fetchedAtUtc,
      );
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

      final cachedRows = await _local.getHistorical(from: f, to: t);
      final lastFetchedAt = await _local.getHistoricalFetchedAtUtc(
        from: f,
        to: t,
      );
      final stale =
          lastFetchedAt == null ||
          _stalePolicy.isStale(fetchedAtUtc: lastFetchedAt, maxAge: _maxAge);

      final status = await _connectivity.getCurrentStatus();
      final canFetch = status == ConnectivityStatus.online;

      final cachedPoints = cachedRows
          .where(
            (r) =>
                r.date.compareTo(startStr) >= 0 &&
                r.date.compareTo(endStr) <= 0,
          )
          .map((r) => RatePoint(date: r.date, rate: r.rate))
          .toList(growable: false);

      if (!forceRefresh && cachedPoints.isNotEmpty) {
        if (stale && canFetch) {
          unawaited(
            _refreshHistoryByDateRangeInBackground(
              from: f,
              to: t,
              start: start,
              end: end,
              force: false,
            ),
          );
        }
        return Success(cachedPoints);
      }

      if (forceRefresh && canFetch) {
        await _refreshHistoryByDateRangeInForeground(
          from: f,
          to: t,
          start: start,
          end: end,
          force: true,
        );
        final refreshed = await _local.getHistorical(from: f, to: t);
        final points = refreshed
            .where(
              (r) =>
                  r.date.compareTo(startStr) >= 0 &&
                  r.date.compareTo(endStr) <= 0,
            )
            .map((r) => RatePoint(date: r.date, rate: r.rate))
            .toList(growable: false);
        if (points.isEmpty) return const FailureResult(CacheFailure());
        return Success(points);
      }

      if (!canFetch) {
        if (cachedPoints.isNotEmpty) return Success(cachedPoints);
        return const FailureResult(CacheFailure());
      }

      await _refreshHistoryByDateRangeInForeground(
        from: f,
        to: t,
        start: start,
        end: end,
        force: false,
      );
      final refreshed = await _local.getHistorical(from: f, to: t);
      final points = refreshed
          .where(
            (r) =>
                r.date.compareTo(startStr) >= 0 &&
                r.date.compareTo(endStr) <= 0,
          )
          .map((r) => RatePoint(date: r.date, rate: r.rate))
          .toList(growable: false);
      if (points.isEmpty) return const FailureResult(CacheFailure());
      return Success(points);
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }

  Future<void> _refreshHistoryByDateRangeInBackground({
    required String from,
    required String to,
    required DateTime start,
    required DateTime end,
    required bool force,
  }) async {
    try {
      await _refreshHistoryByDateRangeInForeground(
        from: from,
        to: to,
        start: start,
        end: end,
        force: force,
      );
    } catch (_) {
      // swallow
    }
  }

  Future<void> _refreshHistoryByDateRangeInForeground({
    required String from,
    required String to,
    required DateTime start,
    required DateTime end,
    required bool force,
  }) async {
    final fetchedAtUtc = DateTime.now().toUtc();
    final f = from.toUpperCase();
    final t = to.toUpperCase();
    final rng = Random();

    for (
      var d = DateTime.utc(start.year, start.month, start.day);
      !d.isAfter(end);
      d = d.add(const Duration(days: 1))
    ) {
      final dateStr = _fmtDate(d);
      if (!force) {
        final existing = await _local.getHistoricalByDate(
          from: f,
          to: t,
          date: dateStr,
        );
        if (existing != null &&
            !_stalePolicy.isStale(
              fetchedAtUtc: existing.fetchedAtUtc,
              maxAge: _maxAge,
            )) {
          continue; // cached + fresh, skip network
        }
      }

      final res = await _fetchHistoricalOnDateWithRetry(
        date: dateStr,
        rng: rng,
      );
      if (res == null) {
        // Rate-limited and couldn't recover in time; stop the burst.
        break;
      }
      final base = res.base; // usually EUR

      double baseTo(String code) {
        final c = code.toUpperCase();
        if (c == base) return 1.0;
        final r = res.rates[c];
        if (r == null) throw StateError('Missing rate for $c on $dateStr');
        return r;
      }

      final rate = f == t ? 1.0 : (baseTo(t) / baseTo(f));
      await _local.upsertHistoricalDailySnapshot(
        from: f,
        date: dateStr,
        rates: {t: rate},
        fetchedAtUtc: fetchedAtUtc,
      );

      // Small pacing delay to reduce chance of hitting 429 in bursts.
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }

  Future<ApiLayerLatestResponse?> _fetchHistoricalOnDateWithRetry({
    required String date,
    required Random rng,
  }) async {
    const maxAttempts = 5;
    var attempt = 0;
    var backoffMs = 500;

    while (true) {
      try {
        return await _remote.fetchHistoricalOnDate(date: date);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (status == 429 && attempt < maxAttempts) {
          final jitter = rng.nextInt(250);
          await Future<void>.delayed(
            Duration(milliseconds: backoffMs + jitter),
          );
          backoffMs *= 2;
          attempt++;
          continue;
        }
        if (status == 429) {
          return null;
        }
        rethrow;
      } catch (_) {
        // For non-Dio failures, don't loop forever.
        if (attempt >= maxAttempts) return null;
        await Future<void>.delayed(Duration(milliseconds: backoffMs));
        backoffMs *= 2;
        attempt++;
      }
    }
  }

  String _fmtDate(DateTime dtUtc) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dtUtc.year}-${two(dtUtc.month)}-${two(dtUtc.day)}';
  }

  Future<LatestRateQuote> _fetchLatestQuote({
    required String from,
    required String to,
  }) async {
    final res = await _remote.fetchLatestDefault();
    final base = res.base; // usually EUR
    final f = from.toUpperCase();
    final t = to.toUpperCase();

    double baseTo(String code) {
      final c = code.toUpperCase();
      if (c == base) return 1.0;
      final r = res.rates[c];
      if (r == null) throw StateError('Missing rate for $c');
      return r;
    }

    final rate = f == t ? 1.0 : (baseTo(t) / baseTo(f));
    final fetchedAtUtc = res.timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(
            res.timestamp! * 1000,
            isUtc: true,
          )
        : DateTime.now().toUtc();
    return LatestRateQuote(
      from: f,
      to: t,
      rate: rate,
      fetchedAtUtc: fetchedAtUtc,
    );
  }
}
