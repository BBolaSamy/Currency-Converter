class ApiLayerTimeSeriesResponse {
  const ApiLayerTimeSeriesResponse({
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.ratesByDate,
  });

  final String base;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final Map<String, Map<String, double>> ratesByDate; // date -> (code -> rate)

  static ApiLayerTimeSeriesResponse? tryParse(dynamic data) {
    if (data is! Map) return null;
    final success = data['success'];
    if (success is bool && success == false) return null;

    final base = data['base']?.toString();
    final start = data['start_date']?.toString();
    final end = data['end_date']?.toString();
    final rates = data['rates'];
    if (base == null || base.isEmpty) return null;
    if (start == null || start.isEmpty) return null;
    if (end == null || end.isEmpty) return null;
    if (rates is! Map) return null;

    final out = <String, Map<String, double>>{};
    for (final dateEntry in rates.entries) {
      final date = (dateEntry.key ?? '').toString();
      final dayRates = dateEntry.value;
      if (date.isEmpty || dayRates is! Map) continue;
      final dayOut = <String, double>{};
      for (final e in dayRates.entries) {
        final code = (e.key ?? '').toString().trim().toUpperCase();
        if (code.isEmpty) continue;
        final v = e.value;
        if (v is num) dayOut[code] = v.toDouble();
        if (v is String) {
          final d = double.tryParse(v);
          if (d != null) dayOut[code] = d;
        }
      }
      if (dayOut.isNotEmpty) out[date] = dayOut;
    }

    return ApiLayerTimeSeriesResponse(
      base: base.toUpperCase(),
      startDate: start,
      endDate: end,
      ratesByDate: out,
    );
  }
}


