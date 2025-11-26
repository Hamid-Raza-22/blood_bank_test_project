import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';

class OnboardingController extends GetxController {
  // Page controller
  final PageController pageController = PageController();

  // Current page index
  var currentPage = 0.obs;

  // Onboarding data
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/gif/blood_1.gif",
      "title": "Easy Donor Search",
      "subtitle":
      "Easy to find available donors nearby \n you will verify when they near your location.",
    },
    {
      "image": "assets/gif/blood_2.gif",
      "title": "Track Your Donor",
      "subtitle":
      "You can track your donor's location \n and know the estimated time to arrive",
    },
    {
      "image": "assets/gif/blood_3.gif",
      "title": "Emergency Post",
      "subtitle":
      "You can post when you have emergency \n situation and the donors can find you \n easily to donate ",
    },
    {
      "image": "assets/gif/blood_4.gif",
      "title": "Get Started Now",
      "subtitle": "Choose an option below to continue.",
    },
  ];

  // Next page
  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
  }

  // Prev page
  void prevPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
  }

  // Skip to last
  void skipToLast() {
    pageController.jumpToPage(onboardingData.length - 1);
  }

  // Change page index
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Navigation from 4th screen
  void goToLogin() {
    Get.to(() => const SignInScreen());
  }

  void goToSignup() {
    Get.to(() => const SignUpScreen());
  }
}
