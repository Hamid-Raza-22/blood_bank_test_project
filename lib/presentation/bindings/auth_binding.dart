import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/google_signin_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../services/session_service.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';

/// Auth Binding - Injects dependencies for Auth feature
/// 
/// Provides AuthViewModel with all required dependencies.
/// Used in GetPage for login, signup, forgot password routes.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Check if AuthViewModel is already registered (it's persistent)
    if (!Get.isRegistered<AuthViewModel>()) {
      Get.lazyPut<AuthViewModel>(
        () => AuthViewModel(
          authRepository: Get.find<AuthRepository>(),
          loginUseCase: Get.find<LoginUseCase>(),
          signupUseCase: Get.find<SignupUseCase>(),
          googleSignInUseCase: Get.find<GoogleSignInUseCase>(),
          logoutUseCase: Get.find<LogoutUseCase>(),
          sessionService: Get.find<SessionService>(),
        ),
        fenix: true, // Recreate if deleted
      );
    }
  }
}
