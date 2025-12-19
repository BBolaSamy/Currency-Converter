import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/currency_dto.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyDto>> fetchCurrencies();
}

@LazySingleton(as: CurrenciesRemoteDataSource)
class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  CurrenciesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CurrencyDto>> fetchCurrencies() async {
    // Expected (v7):
    // GET currencies
    // { "results": { "USD": {"currencyName":"United States Dollar","id":"USD"}, ... } }
    final res = await _dio.get<dynamic>('currencies');
    final data = res.data;

    if (data is! Map) return const [];
    final results = data['results'];
    if (results is! Map) return const [];

    final out = <CurrencyDto>[];
    for (final entry in results.entries) {
      final code = (entry.key ?? '').toString().trim().toUpperCase();
      final v = entry.value;
      if (code.isEmpty || v is! Map) continue;
      final name =
          (v['currencyName'] ?? v['name'] ?? v['currency_name'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      out.add(CurrencyDto(code: code, name: name));
    }
    out.sort((a, b) => a.code.compareTo(b.code));
    return out;
  }
}


