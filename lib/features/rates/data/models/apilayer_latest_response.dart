class ApiLayerLatestResponse {
  const ApiLayerLatestResponse({
    required this.base,
    required this.date, // YYYY-MM-DD
    required this.rates,
    required this.timestamp,
  });

  final String base;
  final String date;
  final int? timestamp;
  final Map<String, double> rates;

  static ApiLayerLatestResponse? tryParse(dynamic data) {
    if (data is! Map) return null;
    final success = data['success'];
    if (success is bool && success == false) return null;
    final base = data['base']?.toString();
    final date = data['date']?.toString();
    final rates = data['rates'];
    if (base == null || base.isEmpty) return null;
    if (date == null || date.isEmpty) return null;
    if (rates is! Map) return null;

    final out = <String, double>{};
    for (final e in rates.entries) {
      final code = (e.key ?? '').toString().trim().toUpperCase();
      if (code.isEmpty) continue;
      final v = e.value;
      if (v is num) out[code] = v.toDouble();
      if (v is String) {
        final d = double.tryParse(v);
        if (d != null) out[code] = d;
      }
    }
    final ts = data['timestamp'];
    return ApiLayerLatestResponse(
      base: base.toUpperCase(),
      date: date,
      rates: out,
      timestamp: ts is num ? ts.toInt() : null,
    );
  }
}


