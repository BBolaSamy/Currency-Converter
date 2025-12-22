import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/currency_dto.dart';
import '../../../rates/data/models/apilayer_api_error.dart';
import '../../../rates/data/models/apilayer_symbols_response.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyDto>> fetchCurrencies();
}

@LazySingleton(as: CurrenciesRemoteDataSource)
class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  CurrenciesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CurrencyDto>> fetchCurrencies() async {
    // APILayer Exchangerates API:
    // GET /symbols?access_key=...
    // Returns { success: true, symbols: { "USD": "United States Dollar", ... } }
    final res = await _dio.get<dynamic>('symbols');
    final err = ApiLayerApiError.tryParse(res.data);
    if (err != null) throw err;
    final parsed = ApiLayerSymbolsResponse.tryParse(res.data);
    if (parsed == null) throw StateError('Unexpected apilayer response');

    final out = <CurrencyDto>[];
    for (final entry in parsed.symbols.entries) {
      out.add(CurrencyDto(code: entry.key, name: entry.value));
    }
    out.sort((a, b) => a.code.compareTo(b.code));
    return out;
  }
}
