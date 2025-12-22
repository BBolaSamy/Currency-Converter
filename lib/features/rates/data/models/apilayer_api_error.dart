class ApiLayerApiError implements Exception {
  const ApiLayerApiError({
    required this.code,
    required this.type,
    required this.info,
  });

  final int? code;
  final String? type;
  final String? info;

  @override
  String toString() =>
      'ApiLayerApiError(code: $code, type: $type, info: $info)';

  static ApiLayerApiError? tryParse(dynamic data) {
    if (data is! Map) return null;
    final success = data['success'];
    if (success is bool && success == true) return null;

    final err = data['error'];
    if (err is! Map) return null;

    final code = err['code'];
    final type = err['type']?.toString();
    final info = err['info']?.toString();
    return ApiLayerApiError(
      code: code is num ? code.toInt() : null,
      type: type,
      info: info,
    );
  }
}
