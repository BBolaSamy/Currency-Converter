import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../app_database.dart';
import '../tables/currencies.dart';

part 'currencies_dao.g.dart';

@DriftAccessor(tables: [Currencies])
@lazySingleton
class CurrenciesDao extends DatabaseAccessor<AppDatabase>
    with _$CurrenciesDaoMixin {
  CurrenciesDao(super.db);

  Future<List<Currency>> getAll() => select(currencies).get();

  Stream<List<Currency>> watchAll() => select(currencies).watch();

  Future<DateTime?> getLastUpdatedAtUtc() async {
    final row =
        await (select(currencies)
              ..orderBy([(t) => OrderingTerm.desc(t.updatedAtUtc)])
              ..limit(1))
            .getSingleOrNull();
    return row?.updatedAtUtc;
  }

  Future<void> replaceAll({required List<CurrenciesCompanion> rows}) async {
    await transaction(() async {
      await delete(currencies).go();
      await batch((b) => b.insertAll(currencies, rows));
    });
  }
}
