import 'package:dio/dio.dart';

import '../result/result.dart';

sealed class ErrorMapper {
  static Failure mapToFailure(Object error, [StackTrace? _]) {
    if (error is DioException) return _mapDio(error);
    return const UnknownFailure();
  }

  static Failure _mapDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status >= 500) return const ServerFailure();
        return ServerFailure(message: 'Request failed ($status).');
      case DioExceptionType.unknown:
        return const NetworkFailure();
    }
  }
}
