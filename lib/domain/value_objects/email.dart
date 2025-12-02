import 'package:equatable/equatable.dart';

/// Email value object with validation
class Email extends Equatable {
  final String value;

  const Email._(this.value);

  /// Factory constructor with validation
  factory Email(String input) {
    final trimmed = input.trim().toLowerCase();
    if (!_isValid(trimmed)) {
      throw EmailValidationException('Invalid email format');
    }
    return Email._(trimmed);
  }

  /// Try to create Email, returns null if invalid
  static Email? tryParse(String input) {
    try {
      return Email(input);
    } catch (_) {
      return null;
    }
  }

  /// Validate email format
  static bool _isValid(String email) {
    if (email.isEmpty) return false;
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  /// Check if email string is valid without creating object
  static bool isValid(String email) => _isValid(email.trim().toLowerCase());

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

class EmailValidationException implements Exception {
  final String message;
  const EmailValidationException(this.message);

  @override
  String toString() => message;
}
