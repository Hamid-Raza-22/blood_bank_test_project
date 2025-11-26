import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controller/auth_controller.dart';
import '../services/firebase_service.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  RxMap userData = RxMap({});
  var isAvailable = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
  }

  void _fetchUser() {
    String? uid = Get.find<AuthController>().firebaseUser.value?.uid;
    if (uid != null) {
      _firestore.collection('users').doc(uid).snapshots().listen((doc) {
        if (doc.exists) {
          userData.value = doc.data()!;
          isAvailable.value = doc.data()?['availability'] ?? true;
        }
      });
    }
  }

  Future<void> updateProfile(
    String name,
    String bloodType,
    File? photo,
    GeoPoint? location,
  ) async {
    try {
      String? photoUrl;
      String uid = Get.find<AuthController>().firebaseUser.value!.uid;
      if (photo != null) {
        photoUrl = await _firebaseService.uploadProfilePhoto(uid, photo);
      }
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'bloodType': bloodType,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (location != null) 'location': location,
      });
      await _firestore.collection('donors').doc(uid).set({
        'userId': uid,
        'bloodType': bloodType,
        'location': location,
        'availability': isAvailable.value,
      }, SetOptions(merge: true));
      Get.snackbar('Success', 'Profile updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  Future<void> toggleAvailability(bool value) async {
    String uid = Get.find<AuthController>().firebaseUser.value!.uid;
    isAvailable.value = value;
    await _firestore.collection('users').doc(uid).update({
      'availability': value,
    });
    await _firestore.collection('donors').doc(uid).update({
      'availability': value,
    });
  }
}
