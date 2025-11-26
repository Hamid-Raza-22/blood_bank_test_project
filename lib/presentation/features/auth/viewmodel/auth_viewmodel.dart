import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../domain/usecases/auth/signup_usecase.dart';
import '../../../../domain/usecases/auth/google_signin_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';

/// Auth ViewModel - handles authentication state and logic
class AuthViewModel extends GetxController {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthViewModel({
    required AuthRepository authRepository,
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _authRepository = authRepository,
        _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _logoutUseCase = logoutUseCase;

  // Observable states
  final _isLoading = false.obs;
  final _errorMessage = RxnString();
  final _isAuthenticated = false.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
    _listenToAuthChanges();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

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
      onSuccess: (user) {
        _clearFields();
        Get.offAllNamed('/home');
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
      onSuccess: (user) {
        _clearFields();
        Get.offAllNamed('/home');
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
      onSuccess: (user) {
        Get.offAllNamed('/home');
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
      onSuccess: (_) {
        Get.offAllNamed('/login');
      },
      onFailure: (failure) {
        _showError(failure.message);
      },
    );
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
}
