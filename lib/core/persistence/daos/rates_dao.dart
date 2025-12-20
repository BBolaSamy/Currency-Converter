import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../app_database.dart';
import '../tables/historical_rates.dart';
import '../tables/latest_rates.dart';

part 'rates_dao.g.dart';

@DriftAccessor(tables: [LatestRates, HistoricalRates])
@lazySingleton
class RatesDao extends DatabaseAccessor<AppDatabase> with _$RatesDaoMixin {
  RatesDao(super.db);

  Future<LatestRate?> getLatest({required String from, required String to}) {
    return (select(latestRates)
          ..where((t) => t.fromCode.equals(from) & t.toCode.equals(to)))
        .getSingleOrNull();
  }

  Future<void> upsertLatest({
    required String from,
    required String to,
    required double rate,
    required DateTime fetchedAtUtc,
  }) async {
    await into(latestRates).insertOnConflictUpdate(
      LatestRatesCompanion(
        fromCode: Value(from),
        toCode: Value(to),
        rate: Value(rate),
        fetchedAtUtc: Value(fetchedAtUtc),
      ),
    );
  }

  Future<void> upsertLatestMany({
    required List<LatestRatesCompanion> rows,
  }) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(latestRates, rows);
    });
  }

  Future<DateTime?> getLatestFetchedAtUtc({
    required String from,
    required String to,
  }) async {
    final row = await getLatest(from: from, to: to);
    return row?.fetchedAtUtc;
  }

  Future<List<HistoricalRate>> getHistorical({
    required String from,
    required String to,
  }) {
    return (select(historicalRates)
          ..where((t) => t.fromCode.equals(from) & t.toCode.equals(to))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<DateTime?> getHistoricalFetchedAtUtc({
    required String from,
    required String to,
  }) async {
    final row =
        await (select(historicalRates)
              ..where((t) => t.fromCode.equals(from) & t.toCode.equals(to))
              ..orderBy([(t) => OrderingTerm.desc(t.fetchedAtUtc)])
              ..limit(1))
            .getSingleOrNull();
    return row?.fetchedAtUtc;
  }

  Future<void> upsertHistoricalMany({
    required List<HistoricalRatesCompanion> rows,
  }) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(historicalRates, rows);
    });
  }
}
