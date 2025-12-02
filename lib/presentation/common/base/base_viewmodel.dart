import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Base ViewModel class for all ViewModels in the application.
/// Provides common functionality for state management.
abstract class BaseViewModel extends GetxController {
  // === Common State ===
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  // === Getters ===
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get hasError => _error.value != null;

  // === State Setters ===
  @protected
  void setLoading(bool value) => _isLoading.value = value;

  @protected
  void setError(String? value) => _error.value = value;

  @protected
  void clearError() => _error.value = null;

  /// Execute an async operation with loading state management
  @protected
  Future<T?> executeAsync<T>({
    required Future<T> Function() action,
    Function(T result)? onSuccess,
    Function(dynamic error)? onError,
    bool showLoading = true,
  }) async {
    if (showLoading) setLoading(true);
    clearError();

    try {
      final result = await action();
      onSuccess?.call(result);
      return result;
    } catch (e) {
      final errorMessage = e.toString();
      setError(errorMessage);
      onError?.call(e);
      debugPrint('${runtimeType.toString()} Error: $e');
      return null;
    } finally {
      if (showLoading) setLoading(false);
    }
  }

  /// Show a snackbar message
  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navigate to a route
  void navigateTo(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }

  /// Navigate and replace current route
  void navigateOff(String route, {dynamic arguments}) {
    Get.offNamed(route, arguments: arguments);
  }

  /// Navigate and clear navigation stack
  void navigateOffAll(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }

  /// Go back
  void goBack({dynamic result}) {
    Get.back(result: result);
  }
}
