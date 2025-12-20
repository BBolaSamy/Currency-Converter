import 'package:injectable/injectable.dart';

import '../../../../core/persistence/daos/currencies_dao.dart';
import '../../../../core/persistence/daos/favorites_dao.dart';
import '../../../../core/persistence/app_database.dart' as db;
import '../../../../core/utils/clock.dart';

@lazySingleton
class CurrenciesLocalDataSource {
  CurrenciesLocalDataSource(
    this._currenciesDao,
    this._favoritesDao,
    this._clock,
  );

  final CurrenciesDao _currenciesDao;
  final FavoritesDao _favoritesDao;
  final Clock _clock;

  Stream<List<db.Currency>> watchCurrenciesRows() => _currenciesDao.watchAll();

  Stream<List<db.Favorite>> watchFavoritesRows() => _favoritesDao.watchAll();

  Future<DateTime?> getCurrenciesUpdatedAtUtc() =>
      _currenciesDao.getLastUpdatedAtUtc();

  Future<void> replaceCurrencies({
    required List<db.CurrenciesCompanion> rows,
  }) => _currenciesDao.replaceAll(rows: rows);

  Future<void> setFavorite({
    required String currencyCode,
    required bool isFavorite,
  }) => _favoritesDao.setFavorite(
    currencyCode: currencyCode,
    isFavorite: isFavorite,
    nowUtc: _clock.nowUtc(),
  );
}
