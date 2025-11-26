import 'package:intl/intl.dart';

/// Date Formatter Utility
class DateFormatter {
  DateFormatter._();

  /// Format date as "MMM dd, yyyy" (e.g., "Jan 15, 2024")
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date as "dd/MM/yyyy"
  static String formatDateShort(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format time as "hh:mm a" (e.g., "02:30 PM")
  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  /// Get relative time (e.g., "2 hours ago", "Yesterday")
  static String timeAgo(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      }
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Format chat timestamp (shows time if today, date otherwise)
  static String formatChatTime(DateTime? date) {
    if (date == null) return '';
    
    if (isToday(date)) {
      return formatTime(date);
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else {
      return formatDateShort(date);
    }
  }
}
