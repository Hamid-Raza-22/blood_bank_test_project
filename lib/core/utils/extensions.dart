import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// String extensions
extension StringExtension on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if valid phone
  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  }

  /// Check if valid password (min 6 chars)
  bool get isValidPassword {
    return length >= 6;
  }
}

/// DateTime extensions
extension DateTimeExtension on DateTime {
  /// Format to readable date
  String get toReadableDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Format to readable time
  String get toReadableTime {
    return DateFormat('h:mm a').format(this);
  }

  /// Format to full readable datetime
  String get toReadableDateTime {
    return DateFormat('MMM dd, yyyy h:mm a').format(this);
  }

  /// Check if today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Get relative time string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// BuildContext extensions
extension ContextExtension on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// List extensions
extension ListExtension<T> on List<T> {
  /// Get first or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last or null
  T? get lastOrNull => isEmpty ? null : last;
}

/// Nullable extensions
extension NullableExtension<T> on T? {
  /// Returns value or default
  T orDefault(T defaultValue) => this ?? defaultValue;
}
