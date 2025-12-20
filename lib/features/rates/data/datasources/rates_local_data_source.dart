import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../../../../core/persistence/daos/rates_dao.dart';
import '../../../../core/persistence/app_database.dart' as db;

@lazySingleton
class RatesLocalDataSource {
  RatesLocalDataSource(this._dao);

  final RatesDao _dao;

  Future<db.LatestRate?> getLatest({required String from, required String to}) {
    return _dao.getLatest(from: from, to: to);
  }

  Future<DateTime?> getLatestFetchedAtUtc({
    required String from,
    required String to,
  }) {
    return _dao.getLatestFetchedAtUtc(from: from, to: to);
  }

  Future<void> upsertLatest({
    required String from,
    required String to,
    required double rate,
    required DateTime fetchedAtUtc,
  }) {
    return _dao.upsertLatest(
      from: from,
      to: to,
      rate: rate,
      fetchedAtUtc: fetchedAtUtc,
    );
  }

  Future<void> upsertLatestMany({
    required String from,
    required Map<String, double> rates,
    required DateTime fetchedAtUtc,
  }) {
    final rows = rates.entries
        .map(
          (e) => db.LatestRatesCompanion(
            fromCode: Value(from.toUpperCase()),
            toCode: Value(e.key.toUpperCase()),
            rate: Value(e.value),
            fetchedAtUtc: Value(fetchedAtUtc),
          ),
        )
        .toList(growable: false);
    return _dao.upsertLatestMany(rows: rows);
  }

  Future<List<db.HistoricalRate>> getHistorical({
    required String from,
    required String to,
  }) {
    return _dao.getHistorical(from: from, to: to);
  }

  Future<DateTime?> getHistoricalFetchedAtUtc({
    required String from,
    required String to,
  }) {
    return _dao.getHistoricalFetchedAtUtc(from: from, to: to);
  }

  Future<void> upsertHistoricalDailySnapshot({
    required String from,
    required String date,
    required Map<String, double> rates,
    required DateTime fetchedAtUtc,
  }) {
    final rows = rates.entries
        .map(
          (e) => db.HistoricalRatesCompanion.insert(
            fromCode: from.toUpperCase(),
            toCode: e.key.toUpperCase(),
            date: date,
            rate: e.value,
            fetchedAtUtc: fetchedAtUtc,
          ),
        )
        .toList(growable: false);
    return _dao.upsertHistoricalMany(rows: rows);
  }
}
