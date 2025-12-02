import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../features/notifications/viewmodel/notification_viewmodel.dart';

/// Notification Binding - Injects dependencies for Notification feature
/// 
/// Provides NotificationViewModel with required repositories.
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    final authRepo = Get.find<AuthRepository>();
    final currentUserId = authRepo.currentUser?.id ?? '';

    Get.lazyPut<NotificationViewModel>(
      () => NotificationViewModel(
        notificationRepository: Get.find<NotificationRepository>(),
        currentUserId: currentUserId,
      ),
    );
  }
}
