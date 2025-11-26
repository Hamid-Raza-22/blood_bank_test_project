import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Save user profile photo
  Future<String?> uploadProfilePhoto(String uid, File file) async {
    try {
      var ref = _storage.ref('users/$uid/profile.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("FirebaseService ERROR: Photo upload failed: $e");
      return null;
    }
  }

  // Send FCM notification (use Firebase Functions for production)
  Future<void> sendFcmNotification(
    String token,
    String title,
    String body,
  ) async {
    try {
      // Replace with your Firebase Functions URL or server endpoint
      final response = await http.post(
        Uri.parse('https://your-firebase-functions-url/sendNotification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'title': title, 'body': body}),
      );
      if (response.statusCode != 200) {
        debugPrint("FirebaseService ERROR: FCM send failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("FirebaseService ERROR: FCM send failed: $e");
    }
  }

  // Notify nearby donors
  Future<void> notifyNearbyDonors(
    String bloodType,
    GeoPoint location,
    String requestId,
  ) async {
    // Requires GeoFlutterFire implementation
    // Query donors collection and send FCM to matching users
  }
}
