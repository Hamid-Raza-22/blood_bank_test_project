import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive Variables
  RxList<DocumentSnapshot> donors = RxList([]);
  RxString selectedBloodType = ''.obs;
  RxString location = ''.obs;
  RxInt units = 1.obs;
  RxDouble lat = 31.5204.obs; // Default: Lahore
  RxDouble lng = 74.3587.obs; // Default: Lahore
  RxString city = ''.obs;
  final String googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // NEW: Flag to trigger navigation after donor is added
  RxBool isDonorAdded = false.obs;

  // Setters
  void setBloodType(String type) => selectedBloodType.value = type;
  void setLocation(String loc) => location.value = loc;
  void setUnits(int u) => units.value = u;
  void setCoordinates(double latitude, double longitude) {
    lat.value = latitude;
    lng.value = longitude;
  }
  void setCity(String c) => city.value = c;

  // Reset form after successful submission
  void resetDonorForm() {
    selectedBloodType.value = '';
    units.value = 1;
    isDonorAdded.value = false;
  }

  // ADD DONOR - Only logic, no snack-bar
  Future<void> addDonor({
    required String userId,
    required String name,
    required String bloodType,
    required int units,
    required GeoPoint location,
    required String city,
    required String photoUrl,
  }) async {
    try {
      // DUPLICATE CHECK
      final existing = await _firestore
          .collection('donors')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'available')
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('Already registered as donor');
      }

      // ADD TO FIRESTORE
      await _firestore.collection('donors').add({
        'userId': userId,
        'name': name,
        'bloodType': bloodType,
        'units': units,
        'location': location,
        'city': city,
        'photoUrl': photoUrl,
        'status': 'available',
        'type': 'donor',
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("RequestController LOG: New donor added: $name ($bloodType)");

      // TRIGGER NAVIGATION IN UI
      isDonorAdded.value = true;

    } catch (e) {
      debugPrint("RequestController ERROR: $e");
      rethrow; // Let UI handle error
    }
  }

  // CREATE BLOOD REQUEST
  Future<void> createBloodRequest({
    required String userId,
    required String patientName,
    required String bloodType,
    required int units,
    required String location,
    required String city,
    String? photoUrl,
    String? hospital,
    String? age,
    String? disease,
    String? contact,
    String? date,
    required String type,
    required String donorId,
  }) async {
    try {
      await _firestore.collection('requests').add({
        'userId': userId,
        'patientName': patientName,
        'bloodType': bloodType,
        'units': units,
        'location': location,
        'city': city,
        'photoUrl': photoUrl ?? 'assets/user1.png',
        'status': 'pending',
        'type': type,
        'donorId': donorId,
        'createdAt': FieldValue.serverTimestamp(),
        if (hospital != null) 'hospital': hospital,
        if (age != null) 'age': age,
        if (disease != null) 'disease': disease,
        if (contact != null) 'contact': contact,
        if (date != null) 'date': date,
      });
      debugPrint("RequestController LOG: Request created for donorId: $donorId");
    } catch (e) {
      debugPrint("RequestController ERROR: $e");
      rethrow;
    }
  }

  // SEARCH DONORS WITHIN 50KM
  Future<void> searchDonors() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('donors')
          .where('bloodType', isEqualTo: selectedBloodType.value)
          .get();

      List<DocumentSnapshot> nearbyDonors = [];
      const double radiusKm = 50.0;

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        GeoPoint? donorLocation = data['location'];
        if (donorLocation != null) {
          double distance = await _getDistance(
            lat.value,
            lng.value,
            donorLocation.latitude,
            donorLocation.longitude,
          );
          if (distance <= radiusKm) {
            nearbyDonors.add(doc);
          }
        }
      }

      donors.value = nearbyDonors;
      debugPrint("RequestController LOG: Found ${donors.length} donors");
    } catch (e) {
      debugPrint("RequestController ERROR: Failed to find donors - $e");
    }
  }

  // DISTANCE MATRIX API CALL
  Future<double> _getDistance(double originLat, double originLng, double destLat, double destLng) async {
    final url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=$originLat,$originLng'
        '&destinations=$destLat,$destLng'
        '&key=$googleApiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          double distance = data['rows'][0]['elements'][0]['distance']['value'] / 1000;
          return distance;
        }
      }
      return double.infinity;
    } catch (e) {
      debugPrint("RequestController ERROR: Distance API failed: $e");
      return double.infinity;
    }
  }

  // HAVERSINE FORMULA (Fallback)
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLng = (lng2 - lng1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // ACCEPT REQUEST
  Future<void> acceptRequest(String donorId, String bloodType, String requestId) async {
    try {
      await _firestore.collection('donors').doc(donorId).update({
        'status': 'accepted',
      });
      await _firestore.collection('requests').doc(requestId).update({
        'status': 'accepted',
      });
      debugPrint("RequestController LOG: Request $requestId accepted for donorId: $donorId");
    } catch (e) {
      debugPrint("RequestController ERROR: Failed to accept request - $e");
      rethrow;
    }
  }
}