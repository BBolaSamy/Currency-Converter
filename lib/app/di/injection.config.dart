// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:currency_converter/app/di/register_module.dart' as _i631;
import 'package:currency_converter/app/env/app_env.dart' as _i153;
import 'package:currency_converter/core/network/connectivity_cubit.dart'
    as _i689;
import 'package:currency_converter/core/network/connectivity_service.dart'
    as _i716;
import 'package:currency_converter/core/persistence/app_database.dart' as _i658;
import 'package:currency_converter/core/persistence/daos/currencies_dao.dart'
    as _i447;
import 'package:currency_converter/core/persistence/daos/favorites_dao.dart'
    as _i357;
import 'package:currency_converter/core/persistence/daos/rates_dao.dart'
    as _i602;
import 'package:currency_converter/core/utils/clock.dart' as _i719;
import 'package:currency_converter/core/utils/stale_policy.dart' as _i330;
import 'package:currency_converter/features/converter/domain/usecases/convert_currency.dart'
    as _i416;
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart'
    as _i630;
import 'package:currency_converter/features/currencies/data/datasources/currencies_local_data_source.dart'
    as _i198;
import 'package:currency_converter/features/currencies/data/datasources/currencies_remote_data_source.dart'
    as _i497;
import 'package:currency_converter/features/currencies/data/repositories/currencies_repository_impl.dart'
    as _i228;
import 'package:currency_converter/features/currencies/domain/repositories/currencies_repository.dart'
    as _i24;
import 'package:currency_converter/features/currencies/domain/usecases/refresh_currencies_if_stale.dart'
    as _i642;
import 'package:currency_converter/features/currencies/domain/usecases/set_currency_favorite.dart'
    as _i808;
import 'package:currency_converter/features/currencies/domain/usecases/watch_currencies.dart'
    as _i289;
import 'package:currency_converter/features/currencies/presentation/bloc/currencies_bloc.dart'
    as _i67;
import 'package:currency_converter/features/historical/presentation/bloc/historical_bloc.dart'
    as _i1068;
import 'package:currency_converter/features/rates/data/datasources/rates_local_data_source.dart'
    as _i1039;
import 'package:currency_converter/features/rates/data/datasources/rates_remote_data_source.dart'
    as _i827;
import 'package:currency_converter/features/rates/data/repositories/rates_repository_impl.dart'
    as _i19;
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart'
    as _i231;
import 'package:currency_converter/features/rates/domain/usecases/get_last_7_days.dart'
    as _i533;
import 'package:currency_converter/features/rates/domain/usecases/get_latest_rate.dart'
    as _i343;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i719.Clock>(() => _i719.Clock());
    gh.lazySingleton<_i658.AppDatabase>(() => _i658.AppDatabase());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i153.AppEnv>(() => _i153.AppEnv());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(gh<_i153.AppEnv>()));
    gh.lazySingleton<_i357.FavoritesDao>(
      () => _i357.FavoritesDao(gh<_i658.AppDatabase>()),
    );
    gh.lazySingleton<_i602.RatesDao>(
      () => _i602.RatesDao(gh<_i658.AppDatabase>()),
    );
    gh.lazySingleton<_i447.CurrenciesDao>(
      () => _i447.CurrenciesDao(gh<_i658.AppDatabase>()),
    );
    gh.lazySingleton<_i497.CurrenciesRemoteDataSource>(
      () => _i497.CurrenciesRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i827.RatesRemoteDataSource>(
      () => _i827.RatesRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i716.ConnectivityService>(
      () => _i716.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i330.StalePolicy>(
      () => _i330.StalePolicy(gh<_i719.Clock>()),
    );
    gh.lazySingleton<_i1039.RatesLocalDataSource>(
      () => _i1039.RatesLocalDataSource(gh<_i602.RatesDao>()),
    );
    gh.lazySingleton<_i198.CurrenciesLocalDataSource>(
      () => _i198.CurrenciesLocalDataSource(
        gh<_i447.CurrenciesDao>(),
        gh<_i357.FavoritesDao>(),
        gh<_i719.Clock>(),
      ),
    );
    gh.lazySingleton<_i231.RatesRepository>(
      () => _i19.RatesRepositoryImpl(
        gh<_i827.RatesRemoteDataSource>(),
        gh<_i1039.RatesLocalDataSource>(),
        gh<_i716.ConnectivityService>(),
        gh<_i330.StalePolicy>(),
      ),
    );
    gh.factory<_i689.ConnectivityCubit>(
      () => _i689.ConnectivityCubit(gh<_i716.ConnectivityService>()),
    );
    gh.lazySingleton<_i24.CurrenciesRepository>(
      () => _i228.CurrenciesRepositoryImpl(
        gh<_i497.CurrenciesRemoteDataSource>(),
        gh<_i198.CurrenciesLocalDataSource>(),
        gh<_i716.ConnectivityService>(),
        gh<_i330.StalePolicy>(),
        gh<_i719.Clock>(),
      ),
    );
    gh.factory<_i289.WatchCurrencies>(
      () => _i289.WatchCurrencies(gh<_i24.CurrenciesRepository>()),
    );
    gh.factory<_i808.SetCurrencyFavorite>(
      () => _i808.SetCurrencyFavorite(gh<_i24.CurrenciesRepository>()),
    );
    gh.factory<_i642.RefreshCurrenciesIfStale>(
      () => _i642.RefreshCurrenciesIfStale(gh<_i24.CurrenciesRepository>()),
    );
    gh.factory<_i343.GetLatestRate>(
      () => _i343.GetLatestRate(gh<_i231.RatesRepository>()),
    );
    gh.factory<_i533.GetLast7Days>(
      () => _i533.GetLast7Days(gh<_i231.RatesRepository>()),
    );
    gh.factory<_i1068.HistoricalBloc>(
      () => _i1068.HistoricalBloc(
        gh<_i533.GetLast7Days>(),
        gh<_i642.RefreshCurrenciesIfStale>(),
      ),
    );
    gh.factory<_i67.CurrenciesBloc>(
      () => _i67.CurrenciesBloc(
        gh<_i289.WatchCurrencies>(),
        gh<_i642.RefreshCurrenciesIfStale>(),
        gh<_i808.SetCurrencyFavorite>(),
      ),
    );
    gh.factory<_i416.ConvertCurrency>(
      () => _i416.ConvertCurrency(gh<_i231.RatesRepository>()),
    );
    gh.factory<_i630.ConverterBloc>(
      () => _i630.ConverterBloc(
        gh<_i416.ConvertCurrency>(),
        gh<_i642.RefreshCurrenciesIfStale>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i631.RegisterModule {}
