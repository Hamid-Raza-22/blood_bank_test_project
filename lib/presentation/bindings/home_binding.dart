import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/donor_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/public_need_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../features/home/viewmodel/home_viewmodel.dart';
import '../features/donors/viewmodel/donor_viewmodel.dart';
import '../features/notifications/viewmodel/notification_viewmodel.dart';
import '../features/profile/viewmodel/profile_viewmodel.dart';

/// Home Binding - Injects dependencies for Home feature
/// 
/// Provides HomeViewModel and all tab ViewModels for MainNavigationView.
/// This includes: DonorViewModel, NotificationViewModel, ProfileViewModel
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final authRepo = Get.find<AuthRepository>();
    final currentUserId = authRepo.currentUser?.id ?? '';

    // Main Home ViewModel
    Get.lazyPut<HomeViewModel>(
      () => HomeViewModel(
        authRepository: authRepo,
        notificationRepository: Get.find<NotificationRepository>(),
        publicNeedRepository: Get.find<PublicNeedRepository>(),
      ),
    );

    // Donor ViewModel (for AllDonorsView tab)
    Get.lazyPut<DonorViewModel>(
      () => DonorViewModel(
        donorRepository: Get.find<DonorRepository>(),
      ),
    );

    // Notification ViewModel (for NotificationView tab)
    Get.lazyPut<NotificationViewModel>(
      () => NotificationViewModel(
        notificationRepository: Get.find<NotificationRepository>(),
        currentUserId: currentUserId,
      ),
    );

    // Profile ViewModel (for ProfileView tab)
    Get.lazyPut<ProfileViewModel>(
      () => ProfileViewModel(
        authRepository: authRepo,
        userRepository: Get.find<UserRepository>(),
        donorRepository: Get.find<DonorRepository>(),
      ),
    );
  }
}
