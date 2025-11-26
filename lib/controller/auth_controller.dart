import 'dart:math';
import 'package:blood_bank_test_project/screens/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:blood_bank_test_project/constant/colors.dart';
import '../services/firebase_auth_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final AuthService _service = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var firebaseUser = Rxn<User>();
  var generatedOtp = ''.obs;
  var verifiedEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    debugPrint("AuthController LOG: Binding auth state changes");
  }

  // Generate random 6-digit OTP
  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Send OTP for Signup
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required");
      return;
    }

    isLoading.value = true;
    try {
      final otp = _generateOtp();
      generatedOtp.value = otp;
      verifiedEmail.value = email;

      await _service.sendOtpEmail(email, otp);

      Get.snackbar("OTP Sent", "An OTP has been sent to $email");
      Get.to(() => VerifyOtpScreen());
    } catch (e) {
      debugPrint("AuthController ERROR: Send OTP failed: $e");
      Get.snackbar("OTP Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String enteredOtp, String password) async {
    if (enteredOtp.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter OTP and password");
      return;
    }

    if (enteredOtp == generatedOtp.value) {
      await signUpWithOtp(verifiedEmail.value, password);
    } else {
      Get.snackbar("Invalid OTP", "The OTP you entered is incorrect");
    }
  }

  // Signup after OTP verified
  Future<void> signUpWithOtp(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _service.signUp(email, password);
      if (user != null) {
        // Save user location and city
        LocationData? loc = await _getUserLocation();
        double lat = loc?.latitude ?? 31.5204;
        double lng = loc?.longitude ?? 74.3587;
        String city = await _getCityFromCoordinates(lat, lng);
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'location': GeoPoint(lat, lng),
          'city': city,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("AuthController LOG: Signup successful: ${user.email}, Location: $city");
        Get.snackbar("Success", "Account created successfully in $city!");
        Get.offAllNamed('/login');
      } else {
        debugPrint("AuthController LOG: Signup failed, user is null");
        Get.snackbar("Error", "Signup failed.");
      }
    } catch (e) {
      debugPrint("AuthController ERROR: Signup failed: $e");
      Get.snackbar("Signup Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Normal Email Login
  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    isLoading.value = true;
    try {
      final user = await _service.signIn(email, password);
      if (user != null) {
        // Save user location and city
        LocationData? loc = await _getUserLocation();
        double lat = loc?.latitude ?? 31.5204;
        double lng = loc?.longitude ?? 74.3587;
        String city = await _getCityFromCoordinates(lat, lng);
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'location': GeoPoint(lat, lng),
          'city': city,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("AuthController LOG: Sign-in successful: ${user.email}, Location: $city");
        // Save FCM token for notifications
        await _saveFcmToken(user.uid);
        Get.snackbar("Success", "Logged in successfully in $city!");
        Get.offAllNamed('/profile');
      } else {
        debugPrint("AuthController LOG: Sign-in failed, user is null");
        Get.snackbar("Error", "Sign-in failed.");
      }
    } catch (e) {
      debugPrint("AuthController ERROR: Sign-in failed: $e");
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Send OTP for password reset
  Future<void> sendResetOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required");
      return;
    }

    isLoading.value = true;
    try {
      final otp = _generateOtp();
      generatedOtp.value = otp;
      verifiedEmail.value = email;

      await _service.sendOtpEmail(email, otp);
      Get.snackbar("OTP Sent", "Password reset OTP sent to $email");
      Get.toNamed('/verifyResetOtp');
    } catch (e) {
      debugPrint("AuthController ERROR: Send reset OTP failed: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP for reset
  Future<void> verifyResetOtp(String enteredOtp) async {
    if (enteredOtp == generatedOtp.value) {
      Get.toNamed('/resetPassword');
    } else {
      Get.snackbar("Invalid OTP", "Please enter a valid OTP");
    }
  }

  // Reset password
  Future<void> resetPassword(String newPassword) async {
    if (newPassword.isEmpty) {
      Get.snackbar("Error", "Password cannot be empty");
      return;
    }

    try {
      await _service.resetPasswordByEmail(verifiedEmail.value, newPassword);
      Get.snackbar("Success", "Password updated successfully!");
      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint("AuthController ERROR: Reset password failed: $e");
      Get.snackbar("Reset Error", e.toString());
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle({bool isSignUp = false}) async {
    isLoading.value = true;
    try {
      debugPrint("AuthController LOG: Starting Google Sign-In (isSignUp: $isSignUp)");
      final user = await _service.signInWithGoogle();
      if (user != null) {
        // Save user location and city
        LocationData? loc = await _getUserLocation();
        double lat = loc?.latitude ?? 31.5204;
        double lng = loc?.longitude ?? 74.3587;
        String city = await _getCityFromCoordinates(lat, lng);
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'location': GeoPoint(lat, lng),
          'city': city,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("AuthController LOG: Google Sign-In successful: ${user.email}, Location: $city");
        // Save FCM token for notifications
        await _saveFcmToken(user.uid);
        Get.snackbar("Success", isSignUp ? "Signed up with Google in $city!" : "Signed in with Google in $city!");
        Get.offAllNamed('/option');
      } else {
        debugPrint("AuthController LOG: Google Sign-In failed, user is null");
        Get.snackbar("Error", "Google Sign-In failed.");
      }
    } catch (e) {
      debugPrint("AuthController ERROR: Google Sign-In failed: $e");
      Get.snackbar(
        "Google Sign-In Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile
  Future<void> updateProfile(String displayName) async {
    isLoading.value = true;
    try {
      await _service.updateUserProfile(displayName);
      // Update user document with new displayName
      if (firebaseUser.value != null) {
        await _firestore.collection('users').doc(firebaseUser.value!.uid).set({
          'name': displayName,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      debugPrint("AuthController LOG: Profile updated successfully: $displayName");
      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      debugPrint("AuthController ERROR: Profile update failed: $e");
      Get.snackbar("Error", "Profile update failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _service.signOut();
    Get.offAllNamed('/login');
    debugPrint("AuthController LOG: Signed out");
  }

  Future<LocationData?> _getUserLocation() async {
    Location location = Location();
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return null;
      }
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) return null;
      }
      return await location.getLocation();
    } catch (e) {
      debugPrint("AuthController ERROR: Failed to get location: $e");
      return null;
    }
  }

  Future<String> _getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      return placemarks.isNotEmpty
          ? placemarks.first.locality ?? placemarks.first.administrativeArea ?? 'Unknown'
          : 'Unknown';
    } catch (e) {
      debugPrint("AuthController ERROR: Failed to get city: $e");
      return 'Unknown';
    }
  }

  // Save FCM token to Firestore for notifications
  Future<void> _saveFcmToken(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("AuthController LOG: FCM Token saved: ${token.substring(0, 20)}...");
      }
    } catch (e) {
      debugPrint("AuthController ERROR: Failed to save FCM token: $e");
    }
  }
}