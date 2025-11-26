import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';

/// Notification repository implementation
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<NotificationEntity>>> getNotificationsForUser(String userId) async {
    try {
      final notifications = await remoteDataSource.getNotificationsForUser(userId);
      return Result.success(notifications);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> getUnreadCount(String userId) async {
    try {
      final count = await remoteDataSource.getUnreadCount(userId);
      return Result.success(count);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<NotificationEntity>> createNotification(NotificationEntity notification) async {
    try {
      final created = await remoteDataSource.createNotification(notification);
      return Result.success(created);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAllAsRead(String userId) async {
    try {
      await remoteDataSource.markAllAsRead(userId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    Map<String, String>? data,
  }) async {
    try {
      await remoteDataSource.sendPushNotification(
        receiverId: receiverId,
        title: title,
        body: body,
        type: type,
        data: data,
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return remoteDataSource.watchNotifications(userId);
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    return remoteDataSource.watchUnreadCount(userId);
  }
}
