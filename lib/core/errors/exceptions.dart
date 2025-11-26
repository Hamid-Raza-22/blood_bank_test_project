/// Base class for exceptions in the app
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException({super.message = 'Server error occurred', super.code});
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection', super.code});
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({super.message = 'Authentication failed', super.code});
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({super.message = 'Validation failed', super.code});
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException({super.message = 'Cache error', super.code});
}

/// Firebase exceptions
class FirebaseAppException extends AppException {
  const FirebaseAppException({super.message = 'Firebase error', super.code});
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({super.message = 'Permission denied', super.code});
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Resource not found', super.code});
}
