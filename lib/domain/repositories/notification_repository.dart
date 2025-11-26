import '../../core/utils/result.dart';
import '../entities/notification_entity.dart';

/// Notification repository interface - defines the contract for notification operations
abstract class NotificationRepository {
  /// Get notifications for user
  Future<Result<List<NotificationEntity>>> getNotificationsForUser(String userId);

  /// Get unread notifications count
  Future<Result<int>> getUnreadCount(String userId);

  /// Create notification
  Future<Result<NotificationEntity>> createNotification(NotificationEntity notification);

  /// Mark notification as read
  Future<Result<void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Result<void>> markAllAsRead(String userId);

  /// Delete notification
  Future<Result<void>> deleteNotification(String notificationId);

  /// Send FCM push notification
  Future<Result<void>> sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    Map<String, String>? data,
  });

  /// Stream notifications
  Stream<List<NotificationEntity>> watchNotifications(String userId);

  /// Stream unread count
  Stream<int> watchUnreadCount(String userId);
}
