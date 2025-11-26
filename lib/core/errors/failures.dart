/// Base class for failures in the app
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.code});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed', super.code});
}

/// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error', super.code});
}

/// Firebase failures
class FirebaseFailure extends Failure {
  const FirebaseFailure({super.message = 'Firebase error', super.code});
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied', super.code});
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found', super.code});
}
