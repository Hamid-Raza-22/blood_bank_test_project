import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../../domain/repositories/notification_repository.dart';

/// Notification ViewModel - handles notification state and logic
class NotificationViewModel extends GetxController {
  final NotificationRepository _notificationRepository;
  final String currentUserId;

  NotificationViewModel({
    required NotificationRepository notificationRepository,
    required this.currentUserId,
  }) : _notificationRepository = notificationRepository;

  // Observable states
  final _notifications = <NotificationEntity>[].obs;
  final _unreadCount = 0.obs;
  final _isLoading = false.obs;

  // Getters
  List<NotificationEntity> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;
  bool get isLoading => _isLoading.value;

  // Grouped notifications
  List<NotificationEntity> get todayNotifications {
    final today = DateTime.now();
    return _notifications.where((n) => _isSameDay(n.createdAt, today)).toList();
  }

  List<NotificationEntity> get yesterdayNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _notifications.where((n) => _isSameDay(n.createdAt, yesterday)).toList();
  }

  List<NotificationEntity> get earlierNotifications {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    return _notifications.where((n) {
      if (n.createdAt == null) return true;
      return !_isSameDay(n.createdAt, today) && !_isSameDay(n.createdAt, yesterday);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _watchNotifications();
    _watchUnreadCount();
  }

  void _watchNotifications() {
    _notificationRepository.watchNotifications(currentUserId).listen((notifs) {
      _notifications.value = notifs;
    });
  }

  void _watchUnreadCount() {
    _notificationRepository.watchUnreadCount(currentUserId).listen((count) {
      _unreadCount.value = count;
    });
  }

  /// Mark notification as read and handle navigation
  Future<void> onNotificationTap(NotificationEntity notification) async {
    // Mark as read
    await _notificationRepository.markAsRead(notification.id);

    // Navigate based on type
    switch (notification.type) {
      case 'new_need':
        Get.toNamed('/publicNeed');
        break;
      case 'need_accepted':
      case 'chat_message':
        final data = notification.data;
        final chatRoomId = data?['chatRoomId'];
        if (chatRoomId != null) {
          Get.toNamed('/chat', arguments: {
            'chatRoomId': chatRoomId,
            'otherUserId': data?['senderId'] ?? '',
            'otherUserName': data?['senderName'] ?? 'User',
            'otherUserPhoto': data?['senderPhoto'] ?? '',
          });
        } else {
          Get.toNamed('/chatList');
        }
        break;
      default:
        break;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    _isLoading.value = true;
    
    final result = await _notificationRepository.markAllAsRead(currentUserId);
    
    result.fold(
      onSuccess: (_) {
        Get.snackbar(
          'Done',
          'All notifications marked as read',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onFailure: (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );

    _isLoading.value = false;
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationRepository.deleteNotification(notificationId);
  }

  /// Get icon for notification type
  IconData getIconForType(String type) {
    switch (type) {
      case 'new_need':
        return Icons.bloodtype;
      case 'need_accepted':
        return Icons.check_circle;
      case 'chat_message':
        return Icons.chat_bubble;
      default:
        return Icons.notifications;
    }
  }

  /// Get color for notification type
  Color getColorForType(String type) {
    switch (type) {
      case 'new_need':
        return Colors.red;
      case 'need_accepted':
        return Colors.green;
      case 'chat_message':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  bool _isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
