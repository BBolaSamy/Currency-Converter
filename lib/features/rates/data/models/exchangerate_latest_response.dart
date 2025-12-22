class ExchangeRateLatestResponse {
  const ExchangeRateLatestResponse({
    required this.baseCode,
    required this.timeLastUpdateUnix,
    required this.conversionRates,
  });

  final String baseCode;
  final int timeLastUpdateUnix;
  final Map<String, double> conversionRates;

  static ExchangeRateLatestResponse? tryParse(dynamic data) {
    if (data is! Map) return null;
    final result = data['result']?.toString();
    if (result != null && result.toLowerCase() != 'success') return null;

    final base = data['base_code']?.toString();
    final t = data['time_last_update_unix'];
    final rates = data['conversion_rates'];
    if (base == null || base.isEmpty) return null;
    if (t is! num) return null;
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

    return ExchangeRateLatestResponse(
      baseCode: base.toUpperCase(),
      timeLastUpdateUnix: t.toInt(),
      conversionRates: out,
    );
  }
}
