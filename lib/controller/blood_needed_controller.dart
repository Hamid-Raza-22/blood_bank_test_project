import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodNeededController extends GetxController {
  // Text Controllers
  final patientNameController = TextEditingController();
  final ageController = TextEditingController();
  final diseaseController = TextEditingController();
  final contactController = TextEditingController();
  final hospitalController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();

  // Observable variables
  var selectedBloodType = ''.obs;
  var units = 0.obs;
  var isLoading = false.obs;

  // Important: Donor info
  String? donorId;       // Document ID from 'donors' collection
  String? donorUserId;   // Firebase Auth UID of the donor

  @override
  void onInit() {
    super.onInit();

    // Safely get donorId from arguments
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('donorId') && args['donorId'] != null) {
      donorId = args['donorId'].toString();
      debugPrint("BloodNeededController: Donor selected → ID: $donorId");
    } else {
      debugPrint("BloodNeededController: No donorId received! Arguments: $args");
      Get.snackbar("Error", "Please select a donor first!", backgroundColor: Colors.red);
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back(); // Close form if no donor selected
      });
    }
  }

  void setBloodType(String type) => selectedBloodType.value = type;
  void setUnits(int value) => units.value = value;

  Future<void> submitRequest() async {
    // Extra safety check
    if (donorId == null || donorId!.isEmpty) {
      Get.snackbar("Error", "No donor selected!", backgroundColor: Colors.red);
      Get.back();
      return;
    }

    // Form validation
    if (patientNameController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        hospitalController.text.trim().isEmpty ||
        selectedBloodType.value.isEmpty ||
        units.value == 0) {
      Get.snackbar("Error", "Please fill all required fields", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "You are not logged in", backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      // Get donor document to extract userId (Auth UID)
      final donorDoc = await FirebaseFirestore.instance
          .collection('donors')
          .doc(donorId)
          .get();

      if (!donorDoc.exists) {
        Get.snackbar("Error", "Donor not found in database!", backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      donorUserId = donorDoc.data()?['userId'] as String?;
      if (donorUserId == null || donorUserId!.isEmpty) {
        Get.snackbar("Error", "Donor information incomplete!", backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      // Send request – most important field: requestToUid
      await FirebaseFirestore.instance.collection('requests').add({
        'donorId': donorId,
        'donorUserId': donorUserId,
        'requestToUid': donorUserId,          // This ensures only this donor sees it
        'requesterId': user.uid,
        'requesterName': user.displayName ?? "Anonymous",
        'patientName': patientNameController.text.trim(),
        'age': ageController.text.trim(),
        'disease': diseaseController.text.trim(),
        'contact': contactController.text.trim(),
        'hospital': hospitalController.text.trim(),
        'location': locationController.text.trim(),
        'bloodType': selectedBloodType.value,
        'units': units.value,
        'date': dateController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Blood request sent successfully!", backgroundColor: Colors.green);
      clearForm();
      Get.offAllNamed('/home');

    } catch (e) {
      debugPrint("Submit Request Error: $e");
      Get.snackbar("Error", "Failed to send request", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    patientNameController.clear();
    ageController.clear();
    diseaseController.clear();
    contactController.clear();
    hospitalController.clear();
    locationController.clear();
    dateController.clear();
    selectedBloodType.value = '';
    units.value = 0;
  }

  @override
  void onClose() {
    patientNameController.dispose();
    ageController.dispose();
    diseaseController.dispose();
    contactController.dispose();
    hospitalController.dispose();
    locationController.dispose();
    dateController.dispose();
    super.onClose();
  }
}