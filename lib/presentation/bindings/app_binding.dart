import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/google_signin_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../services/session_service.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';

/// App-wide Binding - Initializes core ViewModels that persist across screens
/// 
/// This binding runs once at app startup and registers permanent ViewModels.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // AuthViewModel is persistent across app lifecycle
    // It manages authentication state globally
    Get.put<AuthViewModel>(
      AuthViewModel(
        authRepository: Get.find<AuthRepository>(),
        loginUseCase: Get.find<LoginUseCase>(),
        signupUseCase: Get.find<SignupUseCase>(),
        googleSignInUseCase: Get.find<GoogleSignInUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        sessionService: Get.find<SessionService>(),
      ),
      permanent: true,
    );
  }
}

/// Initial binding - for backward compatibility
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    AppBinding().dependencies();
  }
}
