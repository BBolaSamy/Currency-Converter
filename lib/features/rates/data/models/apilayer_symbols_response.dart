class ApiLayerSymbolsResponse {
  const ApiLayerSymbolsResponse({
    required this.symbols,
  });

  final Map<String, String> symbols; // code -> name

  static ApiLayerSymbolsResponse? tryParse(dynamic data) {
    if (data is! Map) return null;
    final success = data['success'];
    if (success is bool && success == false) return null;
    final symbols = data['symbols'];
    if (symbols is! Map) return null;

    final out = <String, String>{};
    for (final e in symbols.entries) {
      final code = (e.key ?? '').toString().trim().toUpperCase();
      final name = (e.value ?? '').toString().trim();
      if (code.isEmpty || name.isEmpty) continue;
      out[code] = name;
    }
    return ApiLayerSymbolsResponse(symbols: out);
  }
}


