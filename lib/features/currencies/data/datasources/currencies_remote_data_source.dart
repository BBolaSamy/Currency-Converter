import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../app/env/app_env.dart';
import '../../../../app/utils/currency_names.dart';
import '../models/currency_dto.dart';
import '../../../rates/data/models/exchangerate_latest_response.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyDto>> fetchCurrencies();
}

@LazySingleton(as: CurrenciesRemoteDataSource)
class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  CurrenciesRemoteDataSourceImpl(this._dio, this._env);

  final Dio _dio;
  final AppEnv _env;

  @override
  Future<List<CurrencyDto>> fetchCurrencies() async {
    // ExchangeRate-API v6:
    // GET /v6/{API_KEY}/latest/USD
    // Response includes conversion_rates map of currency codes -> rates.
    final key = _env.apiKey;
    if (key == null || key.isEmpty) {
      throw StateError('API_KEY is missing (set it in env)');
    }

    final res = await _dio.get<dynamic>('$key/latest/USD');
    final parsed = ExchangeRateLatestResponse.tryParse(res.data);
    if (parsed == null) throw StateError('Unexpected exchangerate-api response');

    final out = <CurrencyDto>[];
    for (final code in parsed.conversionRates.keys) {
      final name = kCurrencyNames[code] ?? code;
      out.add(CurrencyDto(code: code, name: name));
    }
    out.sort((a, b) => a.code.compareTo(b.code));
    return out;
  }
}
