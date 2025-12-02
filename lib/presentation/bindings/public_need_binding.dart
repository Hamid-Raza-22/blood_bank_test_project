import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/public_need_repository.dart';
import '../features/public_needs/viewmodel/public_need_viewmodel.dart';

/// Public Need Binding - Injects dependencies for Public Need feature
/// 
/// Provides PublicNeedViewModel with required repositories.
class PublicNeedBinding extends Bindings {
  @override
  void dependencies() {
    final authRepo = Get.find<AuthRepository>();
    final currentUserId = authRepo.currentUser?.id ?? '';
    final currentUserName = authRepo.currentUser?.name ?? 'User';

    Get.lazyPut<PublicNeedViewModel>(
      () => PublicNeedViewModel(
        publicNeedRepository: Get.find<PublicNeedRepository>(),
        chatRepository: Get.find<ChatRepository>(),
        notificationRepository: Get.find<NotificationRepository>(),
        currentUserId: currentUserId,
        currentUserName: currentUserName,
      ),
    );
  }
}
