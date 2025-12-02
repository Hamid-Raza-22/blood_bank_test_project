import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../features/splash/viewmodel/splash_viewmodel.dart';

/// Splash Binding - Injects dependencies for Splash screen
/// 
/// Provides SplashViewModel for initial app loading and auth check.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashViewModel>(
      () => SplashViewModel(
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}
