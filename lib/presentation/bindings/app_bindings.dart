import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/donor_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/public_need_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/google_signin_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/home/viewmodel/home_viewmodel.dart';
import '../features/chat/viewmodel/chat_viewmodel.dart';
import '../features/donors/viewmodel/donor_viewmodel.dart';
import '../features/notifications/viewmodel/notification_viewmodel.dart';
import '../features/public_needs/viewmodel/public_need_viewmodel.dart';
import '../features/profile/viewmodel/profile_viewmodel.dart';

/// Initial binding - called when app starts
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Auth ViewModel
    Get.lazyPut<AuthViewModel>(
      () => AuthViewModel(
        authRepository: Get.find<AuthRepository>(),
        loginUseCase: Get.find<LoginUseCase>(),
        signupUseCase: Get.find<SignupUseCase>(),
        googleSignInUseCase: Get.find<GoogleSignInUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      fenix: true,
    );
  }
}

/// Home binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(
      () => HomeViewModel(
        authRepository: Get.find<AuthRepository>(),
        notificationRepository: Get.find<NotificationRepository>(),
        publicNeedRepository: Get.find<PublicNeedRepository>(),
      ),
    );
  }
}

/// Chat binding
class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final authRepo = Get.find<AuthRepository>();
    final currentUserId = authRepo.currentUser?.id ?? '';

    Get.lazyPut<ChatViewModel>(
      () => ChatViewModel(
        chatRepository: Get.find<ChatRepository>(),
        userRepository: Get.find(),
        notificationRepository: Get.find<NotificationRepository>(),
        currentUserId: currentUserId,
      ),
    );
  }
}

/// Donor binding
class DonorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonorViewModel>(
      () => DonorViewModel(
        donorRepository: Get.find<DonorRepository>(),
      ),
    );
  }
}

/// Notification binding
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

/// Public Need binding
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

/// Profile binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileViewModel>(
      () => ProfileViewModel(
        authRepository: Get.find<AuthRepository>(),
        userRepository: Get.find<UserRepository>(),
        donorRepository: Get.find<DonorRepository>(),
      ),
    );
  }
}
