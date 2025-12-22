import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/apilayer_api_error.dart';
import '../models/apilayer_latest_response.dart';

abstract class RatesRemoteDataSource {
  /// GET /latest?access_key=...
  /// No extra params (defaults to base=EUR and returns full rates list).
  Future<ApiLayerLatestResponse> fetchLatestDefault();

  /// GET /{YYYY-MM-DD}?access_key=...
  /// No extra params. Returns historical rates for that date (base=EUR).
  Future<ApiLayerLatestResponse> fetchHistoricalOnDate({required String date});
}

@LazySingleton(as: RatesRemoteDataSource)
class RatesRemoteDataSourceImpl implements RatesRemoteDataSource {
  RatesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ApiLayerLatestResponse> fetchLatestDefault() async {
    final res = await _dio.get<dynamic>('latest');
    final err = ApiLayerApiError.tryParse(res.data);
    if (err != null) throw err;
    final parsed = ApiLayerLatestResponse.tryParse(res.data);
    if (parsed == null) throw StateError('Unexpected apilayer response');
    return parsed;
  }

  @override
  Future<ApiLayerLatestResponse> fetchHistoricalOnDate({
    required String date,
  }) async {
    final res = await _dio.get<dynamic>(date);
    final err = ApiLayerApiError.tryParse(res.data);
    if (err != null) throw err;
    final parsed = ApiLayerLatestResponse.tryParse(res.data);
    if (parsed == null) throw StateError('Unexpected apilayer response');
    return parsed;
  }
}
