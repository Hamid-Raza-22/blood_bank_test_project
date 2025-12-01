import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/fcm_service.dart';

class PublicNeedController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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
  var publicNeeds = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPublicNeeds();
  }

  void setBloodType(String type) => selectedBloodType.value = type;
  void setUnits(int value) => units.value = value;

  // Fetch all public needs (excluding current user's own requests)
  void fetchPublicNeeds() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    // Only use where clause, sort client-side to avoid index requirement
    _firestore
        .collection('public_needs')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      // Filter out current user's own requests and sort client-side
      final filtered = snapshot.docs
          .where((doc) => doc['requesterId'] != currentUserId)
          .toList();
      
      // Sort by createdAt descending (client-side)
      filtered.sort((a, b) {
        final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
        final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
      
      publicNeeds.value = filtered;
    });
  }

  // Submit a public need (broadcasts to all users)
  Future<void> submitPublicNeed() async {
    // Form validation
    if (patientNameController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        hospitalController.text.trim().isEmpty ||
        selectedBloodType.value.isEmpty ||
        units.value == 0) {
      Get.snackbar("Error", "Please fill all required fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "You are not logged in",
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      // Create public need document
      final docRef = await _firestore.collection('public_needs').add({
        'requesterId': user.uid,
        'requesterName': user.displayName ?? "Anonymous",
        'requesterEmail': user.email ?? "",
        'requesterPhoto': user.photoURL ?? "",
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
        'acceptedBy': null,
        'acceptedByName': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("PublicNeedController: Need created with ID: ${docRef.id}");

      // TODO: Send FCM notification to all users
      await _sendNotificationToAllUsers(docRef.id);

      Get.snackbar("Success", "Blood request posted successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      clearForm();
      Get.back(); // Close the form

    } catch (e) {
      debugPrint("PublicNeedController ERROR: $e");
      Get.snackbar("Error", "Failed to post request",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Accept a public need
  Future<void> acceptNeed(String needId, Map<String, dynamic> needData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "You are not logged in",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Update the need status
      await _firestore.collection('public_needs').doc(needId).update({
        'status': 'accepted',
        'acceptedBy': user.uid,
        'acceptedByName': user.displayName ?? "Anonymous",
        'acceptedByPhoto': user.photoURL ?? "",
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      // Create a chat room between requester and acceptor
      final chatRoomId = await _createChatRoom(
        needId: needId,
        requesterId: needData['requesterId'],
        requesterName: needData['requesterName'],
        requesterPhoto: needData['requesterPhoto'] ?? "",
        acceptorId: user.uid,
        acceptorName: user.displayName ?? "Anonymous",
        acceptorPhoto: user.photoURL ?? "",
        bloodType: needData['bloodType'],
      );

      // Send notification to requester
      await _sendAcceptanceNotification(
        needData['requesterId'],
        user.displayName ?? "Someone",
        needData['bloodType'],
        chatRoomId,
      );

      Get.snackbar("Success", "Request accepted! You can now chat with the requester.",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Navigate to chat
      Get.toNamed('/chat', arguments: {
        'chatRoomId': chatRoomId,
        'otherUserId': needData['requesterId'],
        'otherUserName': needData['requesterName'],
        'otherUserPhoto': needData['requesterPhoto'] ?? "",
      });

    } catch (e) {
      debugPrint("PublicNeedController ERROR accepting need: $e");
      Get.snackbar("Error", "Failed to accept request",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Create or get existing chat room between two users (ONE chat per user pair)
  Future<String> _createChatRoom({
    required String needId,
    required String requesterId,
    required String requesterName,
    required String requesterPhoto,
    required String acceptorId,
    required String acceptorName,
    required String acceptorPhoto,
    required String bloodType,
  }) async {
    // Create deterministic chat room ID (same users = same chat room, regardless of request)
    final List<String> ids = [requesterId, acceptorId]..sort();
    final chatRoomId = '${ids[0]}_${ids[1]}';

    // Check if chat room already exists between these users
    final existingRoom = await _firestore.collection('chat_rooms').doc(chatRoomId).get();
    
    if (!existingRoom.exists) {
      // Create new chat room
      await _firestore.collection('chat_rooms').doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'participants': [requesterId, acceptorId],
        'participantNames': {
          requesterId: requesterName,
          acceptorId: acceptorName,
        },
        'participantPhotos': {
          requesterId: requesterPhoto,
          acceptorId: acceptorPhoto,
        },
        'lastMessage': 'Request accepted! Start chatting...',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add initial system message
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': 'system',
        'message': '$acceptorName accepted the blood request for $bloodType.',
        'type': 'system',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Chat room exists - just add a message about the new accepted request
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': 'system',
        'message': '$acceptorName accepted another blood request for $bloodType.',
        'type': 'system',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Update last message
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'lastMessage': 'New request accepted',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  // Send FCM notification to all users about new need
  Future<void> _sendNotificationToAllUsers(String needId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    // Send via FCM HTTP v1 API
    await FCMService.sendNewNeedNotification(
      needId: needId,
      requesterName: currentUser?.displayName ?? "Someone",
      bloodType: selectedBloodType.value,
    );
    
    // Also store in Firestore for in-app notifications
    final usersSnapshot = await _firestore.collection('users').get();
    for (var userDoc in usersSnapshot.docs) {
      if (userDoc.id != currentUser?.uid) {
        await _firestore.collection('notifications').add({
          'userId': userDoc.id,
          'type': 'new_need',
          'needId': needId,
          'title': 'New Blood Request',
          'body': '${currentUser?.displayName ?? "Someone"} needs ${selectedBloodType.value} blood',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Send FCM notification to requester when their need is accepted
  Future<void> _sendAcceptanceNotification(
    String requesterId,
    String acceptorName,
    String bloodType,
    String chatRoomId,
  ) async {
    // Send via FCM HTTP v1 API
    await FCMService.sendAcceptanceNotification(
      requesterId: requesterId,
      acceptorName: acceptorName,
      bloodType: bloodType,
      chatRoomId: chatRoomId,
    );
    
    // Also store in Firestore for in-app notifications
    await _firestore.collection('notifications').add({
      'userId': requesterId,
      'type': 'need_accepted',
      'title': 'Request Accepted!',
      'body': '$acceptorName accepted your $bloodType blood request',
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
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
