import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../app/env/app_env.dart';
import '../models/exchangerate_latest_response.dart';

abstract class RatesRemoteDataSource {
  Future<ExchangeRateLatestResponse> fetchLatestForBase({
    required String base,
  });
}

@LazySingleton(as: RatesRemoteDataSource)
class RatesRemoteDataSourceImpl implements RatesRemoteDataSource {
  RatesRemoteDataSourceImpl(this._dio, this._env);

  final Dio _dio;
  final AppEnv _env;

  @override
  Future<ExchangeRateLatestResponse> fetchLatestForBase({
    required String base,
  }) async {
    final key = _env.apiKey;
    if (key == null || key.isEmpty) {
      throw StateError('API_KEY is missing (set it in env)');
    }
    final b = base.trim().toUpperCase();
    final res = await _dio.get<dynamic>('$key/latest/$b');
    final parsed = ExchangeRateLatestResponse.tryParse(res.data);
    if (parsed == null) throw StateError('Unexpected exchangerate-api response');
    return parsed;
  }
}
