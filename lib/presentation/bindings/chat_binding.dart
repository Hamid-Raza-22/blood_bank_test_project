import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../features/chat/viewmodel/chat_viewmodel.dart';

/// Chat Binding - Injects dependencies for Chat feature
/// 
/// Provides ChatViewModel with required repositories.
class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final authRepo = Get.find<AuthRepository>();
    final currentUserId = authRepo.currentUser?.id ?? '';

    Get.lazyPut<ChatViewModel>(
      () => ChatViewModel(
        chatRepository: Get.find<ChatRepository>(),
        userRepository: Get.find<UserRepository>(),
        notificationRepository: Get.find<NotificationRepository>(),
        currentUserId: currentUserId,
      ),
    );
  }
}
