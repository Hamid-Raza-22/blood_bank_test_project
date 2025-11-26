import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Navigate to Need Blood screen
  void navigateToNeedBlood() {
    if (isLoggedIn) {
      Get.toNamed('/need');
      debugPrint("OptionController LOG: Navigated to BloodNeededScreen");
    } else {
      Get.snackbar('Error', 'Please log in to request blood');
      Get.toNamed('/login');
    }
  }

  // Navigate to Find Donor screen
  void navigateToFindDonor() {
    if (isLoggedIn) {
      Get.toNamed('/donors');
      debugPrint("OptionController LOG: Navigated to FindDonorScreen");
    } else {
      Get.snackbar('Error', 'Please log in to find donors');
      Get.toNamed('/login');
    }
  }

  // Navigate to HomeScreen
  void navigateToHome() {
    if (isLoggedIn) {
      Get.offAllNamed('/home');
      debugPrint("OptionController LOG: Navigated to HomeScreen");
    } else {
      Get.snackbar('Error', 'Please log in to continue');
      Get.toNamed('/login');
    }
  }
}