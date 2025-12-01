import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../services/session_service.dart';
import '../../../routes/app_routes.dart';

/// SplashViewModel - handles initial app state check and navigation
/// 
/// Uses SessionService for persistent login check:
/// 1. Checks if onboarding is completed
/// 2. Checks for valid session in secure storage
/// 3. Navigates to appropriate screen based on auth state
class SplashViewModel extends GetxController {
  final AuthRepository _authRepository;
  final SessionService _sessionService;

  SplashViewModel({
    required AuthRepository authRepository,
    SessionService? sessionService,
  })  : _authRepository = authRepository,
        _sessionService = sessionService ?? Get.find<SessionService>();

  // Observable states
  final _isLoading = true.obs;
  final _statusMessage = 'Initializing...'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get statusMessage => _statusMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Initialize app and determine navigation
  /// 
  /// Flow:
  /// 1. Check onboarding status
  /// 2. Check persistent session using SessionService
  /// 3. Verify Firebase auth state
  /// 4. Navigate to Option (logged in) or Login (not logged in)
  Future<void> _initializeApp() async {
    try {
      _statusMessage.value = 'Checking app status...';
      
      // Small delay for splash screen visibility
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check onboarding status
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

      if (!onboardingCompleted) {
        _statusMessage.value = 'Welcome!';
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      // Check persistent login session
      _statusMessage.value = 'Checking login status...';
      
      final hasValidSession = await _sessionService.isSessionValid();
      
      if (hasValidSession && _authRepository.isAuthenticated) {
        // User has a valid persistent session
        final userEmail = await _sessionService.getUserEmail();
        debugPrint('SplashViewModel: Valid session found for $userEmail');
        
        _statusMessage.value = 'Welcome back!';
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Refresh token in background
        _sessionService.refreshToken();
        
        // Navigate to Option screen for logged-in users
        Get.offAllNamed(AppRoutes.option);
      } else {
        // No valid session - clear any stale data and go to login
        debugPrint('SplashViewModel: No valid session, redirecting to login');
        await _sessionService.clearSession();
        
        _statusMessage.value = 'Please login';
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('SplashViewModel ERROR: $e');
      _statusMessage.value = 'Error initializing app';
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoutes.login);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Mark onboarding as completed and navigate
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offAllNamed(AppRoutes.login);
  }
}
