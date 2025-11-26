import '../../../core/utils/result.dart';
import '../../entities/notification_entity.dart';
import '../../repositories/notification_repository.dart';
import '../base_usecase.dart';

/// Watch Notifications Stream Use Case
class WatchNotificationsUseCase implements StreamUseCase<List<NotificationEntity>, String> {
  final NotificationRepository repository;

  WatchNotificationsUseCase({required this.repository});

  @override
  Stream<List<NotificationEntity>> call(String userId) {
    return repository.watchNotifications(userId);
  }
}

/// Watch Unread Count Stream Use Case
class WatchUnreadCountUseCase implements StreamUseCase<int, String> {
  final NotificationRepository repository;

  WatchUnreadCountUseCase({required this.repository});

  @override
  Stream<int> call(String userId) {
    return repository.watchUnreadCount(userId);
  }
}

/// Mark Notification as Read Use Case
class MarkNotificationAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase({required this.repository});

  @override
  Future<Result<void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}

/// Mark All Notifications as Read Use Case
class MarkAllNotificationsAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase({required this.repository});

  @override
  Future<Result<void>> call(String userId) {
    return repository.markAllAsRead(userId);
  }
}

/// Send Push Notification Use Case
class SendPushNotificationUseCase implements UseCase<void, PushNotificationParams> {
  final NotificationRepository repository;

  SendPushNotificationUseCase({required this.repository});

  @override
  Future<Result<void>> call(PushNotificationParams params) {
    return repository.sendPushNotification(
      receiverId: params.receiverId,
      title: params.title,
      body: params.body,
      type: params.type,
      data: params.data,
    );
  }
}

class PushNotificationParams {
  final String receiverId;
  final String title;
  final String body;
  final String type;
  final Map<String, String>? data;

  PushNotificationParams({
    required this.receiverId,
    required this.title,
    required this.body,
    required this.type,
    this.data,
  });
}
