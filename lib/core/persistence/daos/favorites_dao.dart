import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../app_database.dart';
import '../tables/favorites.dart';

part 'favorites_dao.g.dart';

@DriftAccessor(tables: [Favorites])
@lazySingleton
class FavoritesDao extends DatabaseAccessor<AppDatabase> with _$FavoritesDaoMixin {
  FavoritesDao(super.db);

  Stream<List<Favorite>> watchAll() => select(favorites).watch();

  Future<Set<String>> getAllCodes() async {
    final rows = await select(favorites).get();
    return rows.map((e) => e.currencyCode).toSet();
  }

  Future<void> setFavorite({
    required String currencyCode,
    required bool isFavorite,
    required DateTime nowUtc,
  }) async {
    if (isFavorite) {
      await into(favorites).insertOnConflictUpdate(
        FavoritesCompanion(
          currencyCode: Value(currencyCode),
          createdAtUtc: Value(nowUtc),
        ),
      );
    } else {
      await (delete(favorites)..where((t) => t.currencyCode.equals(currencyCode)))
          .go();
    }
  }
}


