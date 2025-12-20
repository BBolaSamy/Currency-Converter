import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/connectivity_status.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/stale_policy.dart';
import '../../../../core/persistence/app_database.dart' as db;
import '../../../../core/domain/entities/currency_entity.dart';
import '../../domain/entities/currency.dart';
import '../../domain/repositories/currencies_repository.dart';
import '../datasources/currencies_local_data_source.dart';
import '../datasources/currencies_remote_data_source.dart';

@LazySingleton(as: CurrenciesRepository)
class CurrenciesRepositoryImpl implements CurrenciesRepository {
  CurrenciesRepositoryImpl(
    this._remote,
    this._local,
    this._connectivity,
    this._stalePolicy,
    this._clock,
  );

  final CurrenciesRemoteDataSource _remote;
  final CurrenciesLocalDataSource _local;
  final ConnectivityService _connectivity;
  final StalePolicy _stalePolicy;
  final Clock _clock;

  static const _maxAge = Duration(hours: 12);

  @override
  Stream<List<CurrencyItem>> watchCurrencies() {
    return Rx.combineLatest2<
      List<db.Currency>,
      List<db.Favorite>,
      List<CurrencyItem>
    >(_local.watchCurrenciesRows(), _local.watchFavoritesRows(), (
      currencies,
      favorites,
    ) {
      final favSet = favorites.map((e) => e.currencyCode).toSet();
      final items = currencies
          .map(
            (c) => CurrencyItem(
              currency: CurrencyEntity(code: c.code, name: c.name),
              isFavorite: favSet.contains(c.code),
            ),
          )
          .toList();
      // Favorites first, then alphabetical
      items.sort((a, b) {
        final fav = (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0);
        if (fav != 0) return fav;
        return a.currency.code.compareTo(b.currency.code);
      });
      return items;
    });
  }

  @override
  Future<Result<void>> refreshCurrenciesIfStale() async {
    try {
      final lastUpdated = await _local.getCurrenciesUpdatedAtUtc();
      final isStale =
          lastUpdated == null ||
          _stalePolicy.isStale(fetchedAtUtc: lastUpdated, maxAge: _maxAge);
      if (!isStale) return const Success(null);

      final status = await _connectivity.getCurrentStatus();
      if (status == ConnectivityStatus.offline) {
        // Offline-first: keep cached data; don’t fail refresh.
        return const Success(null);
      }

      final remote = await _remote.fetchCurrencies();
      final now = _clock.nowUtc();
      final rows = remote
          .map(
            (dto) => db.CurrenciesCompanion.insert(
              code: dto.code,
              name: dto.name,
              updatedAtUtc: now,
            ),
          )
          .toList();
      await _local.replaceCurrencies(rows: rows);
      return const Success(null);
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }

  @override
  Future<Result<void>> setFavorite({
    required String currencyCode,
    required bool isFavorite,
  }) async {
    try {
      await _local.setFavorite(
        currencyCode: currencyCode,
        isFavorite: isFavorite,
      );
      return const Success(null);
    } catch (e, st) {
      return FailureResult(ErrorMapper.mapToFailure(e, st));
    }
  }
}
