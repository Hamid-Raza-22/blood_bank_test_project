import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../domain/usecases/auth/signup_usecase.dart';
import '../../../../domain/usecases/auth/google_signin_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../services/session_service.dart';
import '../../../routes/app_routes.dart';

/// Auth ViewModel - handles authentication state and logic
/// 
/// Follows Clean Architecture:
/// - Uses UseCases for business logic
/// - Uses Repository for data access
/// - Uses SessionService for persistent login
/// - No business logic in Views
class AuthViewModel extends GetxController {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final LogoutUseCase _logoutUseCase;
  final SessionService _sessionService;

  AuthViewModel({
    required AuthRepository authRepository,
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required LogoutUseCase logoutUseCase,
    SessionService? sessionService,
  })  : _authRepository = authRepository,
        _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _logoutUseCase = logoutUseCase,
        _sessionService = sessionService ?? Get.find<SessionService>();

  // === Observable States ===
  final _isLoading = false.obs;
  final _errorMessage = RxnString();
  final _isAuthenticated = false.obs;
  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;
  final _rememberMe = false.obs;
  final _generatedOtp = ''.obs;

  // === Form Controllers ===
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late final List<TextEditingController> otpControllers;

  // === Getters ===
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  bool get rememberMe => _rememberMe.value;

  @override
  void onInit() {
    super.onInit();
    otpControllers = List.generate(6, (_) => TextEditingController());
    _checkAuthStatus();
    _listenToAuthChanges();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    for (final controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // === UI State Actions ===
  void togglePasswordVisibility() => _isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => _isConfirmPasswordVisible.toggle();
  void setRememberMe(bool value) => _rememberMe.value = value;

  void _checkAuthStatus() {
    _isAuthenticated.value = _authRepository.isAuthenticated;
  }

  void _listenToAuthChanges() {
    _authRepository.authStateChanges.listen((user) {
      _isAuthenticated.value = user != null;
    });
  }

  /// Sign in with email and password
  Future<bool> signIn() async {
    if (!_validateEmail() || !_validatePassword()) return false;

    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _loginUseCase(LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text,
    ));

    _isLoading.value = false;

    return result.fold(
      onSuccess: (user) async {
        // Save session for persistent login
        await _sessionService.saveSession(
          userId: user.id,
          email: user.email,
          authProvider: 'email',
        );
        _clearFields();
        _navigateAfterAuth();
        return true;
      },
      onFailure: (failure) {
        _errorMessage.value = failure.message;
        _showError(failure.message);
        return false;
      },
    );
  }

  /// Sign up with email and password
  Future<bool> signUp() async {
    if (!_validateEmail() || !_validatePassword() || !_validateConfirmPassword()) {
      return false;
    }

    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _signupUseCase(SignupParams(
      email: emailController.text.trim(),
      password: passwordController.text,
    ));

    _isLoading.value = false;

    return result.fold(
      onSuccess: (user) async {
        // Save session for persistent login
        await _sessionService.saveSession(
          userId: user.id,
          email: user.email,
          authProvider: 'email',
        );
        _clearFields();
        _navigateAfterAuth();
        return true;
      },
      onFailure: (failure) {
        _errorMessage.value = failure.message;
        _showError(failure.message);
        return false;
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _googleSignInUseCase();

    _isLoading.value = false;

    return result.fold(
      onSuccess: (user) async {
        // Save session for persistent login
        await _sessionService.saveSession(
          userId: user.id,
          email: user.email,
          authProvider: 'google',
        );
        _navigateAfterAuth();
        return true;
      },
      onFailure: (failure) {
        _errorMessage.value = failure.message;
        _showError(failure.message);
        return false;
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading.value = true;

    final result = await _logoutUseCase();

    _isLoading.value = false;

    result.fold(
      onSuccess: (_) async {
        // Clear session from secure storage
        await _sessionService.clearSession();
        Get.offAllNamed(AppRoutes.login);
      },
      onFailure: (failure) {
        _showError(failure.message);
      },
    );
  }

  /// Navigate to Option screen after successful authentication
  void _navigateAfterAuth() {
    Get.offAllNamed(AppRoutes.option);
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail() async {
    if (!_validateEmail()) return false;

    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _authRepository.sendPasswordResetEmail(
      emailController.text.trim(),
    );

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
        Get.snackbar(
          'Success',
          'Password reset email sent',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      },
      onFailure: (failure) {
        _errorMessage.value = failure.message;
        _showError(failure.message);
        return false;
      },
    );
  }

  bool _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showError('Email is required');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      _showError('Invalid email format');
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      _showError('Password is required');
      return false;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword() {
    if (passwordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return false;
    }
    return true;
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void clearError() {
    _errorMessage.value = null;
  }

  // === OTP Methods ===
  
  /// Generate random 6-digit OTP
  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Get OTP from input fields
  String get enteredOtp {
    return otpControllers.map((c) => c.text).join();
  }

  /// Clear OTP fields
  void _clearOtpFields() {
    for (final controller in otpControllers) {
      controller.clear();
    }
  }

  /// Verify OTP entered by user
  Future<bool> verifyOtp() async {
    final otp = enteredOtp;
    if (otp.length != 6) {
      _showError('Please enter complete OTP');
      return false;
    }

    if (otp != _generatedOtp.value) {
      _showError('Invalid OTP');
      return false;
    }

    _clearOtpFields();
    Get.snackbar('Success', 'OTP verified successfully');
    return true;
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (emailController.text.isEmpty) {
      _showError('Email is required');
      return;
    }

    _isLoading.value = true;
    try {
      final otp = _generateOtp();
      _generatedOtp.value = otp;
      // In real app, send via email service
      debugPrint('OTP: $otp'); // For testing
      Get.snackbar('OTP Sent', 'New OTP sent to ${emailController.text}');
    } catch (e) {
      _showError('Failed to send OTP');
    } finally {
      _isLoading.value = false;
    }
  }
}
