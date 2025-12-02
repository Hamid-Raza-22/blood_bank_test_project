import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/donor_repository.dart';
import '../features/profile/viewmodel/profile_viewmodel.dart';

/// Profile Binding - Injects dependencies for Profile feature
/// 
/// Provides ProfileViewModel with required repositories.
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
