sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is FailureResult<T>) return failure(self.failure);
    throw StateError('Unhandled Result subtype: $runtimeType');
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}

sealed class Failure {
  const Failure({required this.message});
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error. Check your connection.',
  });
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error. Please try again.'});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'No cached data available.'});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong.'});
}
