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
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i153.AppEnv>(() => _i153.AppEnv());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(gh<_i153.AppEnv>()));
    gh.lazySingleton<_i716.ConnectivityService>(
      () => _i716.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.factory<_i689.ConnectivityCubit>(
      () => _i689.ConnectivityCubit(gh<_i716.ConnectivityService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i631.RegisterModule {}
