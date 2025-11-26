import '../errors/failures.dart';

/// A Result type that represents either a success or failure
/// Alternative to Either from dartz package
sealed class Result<T> {
  const Result();

  /// Creates a successful result
  factory Result.success(T data) = Success<T>;

  /// Creates a failed result
  factory Result.failure(Failure failure) = Error<T>;

  /// Returns true if this is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure
  bool get isFailure => this is Error<T>;

  /// Gets the data if success, throws if failure
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw Exception('Result is not Success');
  }

  /// Gets the failure if error, throws if success
  Failure get failure {
    if (this is Error<T>) {
      return (this as Error<T>).error;
    }
    throw Exception('Result is not Error');
  }

  /// Maps success value to another type
  Result<R> map<R>(R Function(T value) mapper) {
    if (this is Success<T>) {
      return Result.success(mapper((this as Success<T>).value));
    }
    return Result.failure((this as Error<T>).error);
  }

  /// Executes appropriate callback based on result type
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure((this as Error<T>).error);
  }

  /// Executes callback only if success
  void onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).value);
    }
  }

  /// Executes callback only if failure
  void onFailure(void Function(Failure failure) callback) {
    if (this is Error<T>) {
      callback((this as Error<T>).error);
    }
  }
}

/// Represents a successful result
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

/// Represents a failed result
class Error<T> extends Result<T> {
  final Failure error;
  const Error(this.error);
}
