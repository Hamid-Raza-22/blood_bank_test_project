import 'package:equatable/equatable.dart';

/// Password value object with validation
class Password extends Equatable {
  final String value;

  const Password._(this.value);

  /// Factory constructor with validation
  factory Password(String input) {
    final validationError = _validate(input);
    if (validationError != null) {
      throw PasswordValidationException(validationError);
    }
    return Password._(input);
  }

  /// Try to create Password, returns null if invalid
  static Password? tryParse(String input) {
    try {
      return Password(input);
    } catch (_) {
      return null;
    }
  }

  /// Validate password and return error message if invalid
  static String? _validate(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (password.length > 128) {
      return 'Password is too long';
    }
    return null;
  }

  /// Check if password is valid without creating object
  static bool isValid(String password) => _validate(password) == null;

  /// Get validation error message
  static String? getValidationError(String password) => _validate(password);

  /// Check password strength (0-4)
  static int getStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength.clamp(0, 4);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => '***'; // Never expose password
}

class PasswordValidationException implements Exception {
  final String message;
  const PasswordValidationException(this.message);

  @override
  String toString() => message;
}
