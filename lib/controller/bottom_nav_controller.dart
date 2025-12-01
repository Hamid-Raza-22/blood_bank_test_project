import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Navigation Controller for Bottom Navigation Bar
/// 
/// Only changes the index - actual page switching is handled by
/// MainNavigationScreen using IndexedStack.
class NavController extends GetxController {
  RxInt currentIndex = 0.obs;

  /// Change tab - only updates index, no navigation needed
  /// MainNavigationScreen's IndexedStack handles the page switch
  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      debugPrint("NavController LOG: Tab changed to index: $index");
    }
  }

  /// Reset to home tab
  void goToHome() {
    changeTab(0);
  }

  /// Navigate to main screen with specific tab
  void navigateToTab(int index) {
    currentIndex.value = index;
    Get.offAllNamed('/home');
  }
}
