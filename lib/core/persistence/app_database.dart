import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/currencies_dao.dart';
import 'daos/favorites_dao.dart';
import 'daos/rates_dao.dart';
import 'tables/currencies.dart';
import 'tables/favorites.dart';
import 'tables/historical_rates.dart';
import 'tables/latest_rates.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Currencies, Favorites, LatestRates, HistoricalRates],
  daos: [CurrenciesDao, FavoritesDao, RatesDao],
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Helpful for retention cleanups and range queries by date.
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_historical_rates_date ON historical_rates(date);',
      );
    },
    onUpgrade: (m, from, to) async {
      // v2: introduce indices (no data loss).
      if (from < 2) {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_historical_rates_date ON historical_rates(date);',
        );
      }
    },
    beforeOpen: (details) async {
      // No foreign keys currently, but keep this enabled for future hardening.
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'currency_converter.sqlite',
    native: DriftNativeOptions(
      databaseDirectory: () async {
        final dir = await getApplicationDocumentsDirectory();
        final dbDir = Directory(p.join(dir.path, 'db'));
        if (!dbDir.existsSync()) dbDir.createSync(recursive: true);
        return dbDir;
      },
    ),
  );
}
