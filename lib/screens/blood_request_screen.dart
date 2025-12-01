import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../controller/bottom_nav_controller.dart';
import '../widgets/blood_request_card.dart';
import '../services/fcm_service.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavController>().currentIndex.value = 2;
    });
  }

  void _updateRequestStatus(String requestId, String status, Map<String, dynamic> requestData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      if (status == 'accepted') {
        // Create or get existing chat room between requester and acceptor
        final chatRoomId = await _getOrCreateChatRoom(
          requesterId: requestData['requesterId'],
          requesterName: requestData['requesterName'] ?? 'Unknown',
          requesterPhoto: requestData['requesterPhoto'] ?? '',
          acceptorId: user.uid,
          acceptorName: user.displayName ?? 'Anonymous',
          acceptorPhoto: user.photoURL ?? '',
        );

        // Update request status with chat room info
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .update({
          'status': 'accepted',
          'acceptedBy': user.uid,
          'acceptedByName': user.displayName ?? 'Anonymous',
          'chatRoomId': chatRoomId,
          'acceptedAt': FieldValue.serverTimestamp(),
        });

        // Send notification to requester
        await _sendAcceptanceNotification(
          requesterId: requestData['requesterId'],
          acceptorName: user.displayName ?? 'Someone',
          bloodType: requestData['bloodType'] ?? '',
          chatRoomId: chatRoomId,
        );

        Get.snackbar(
          'Accepted',
          'You have accepted the blood request.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to chat screen
        Get.toNamed('/chat', arguments: {
          'chatRoomId': chatRoomId,
          'otherUserId': requestData['requesterId'],
          'otherUserName': requestData['requesterName'] ?? 'Unknown',
          'otherUserPhoto': requestData['requesterPhoto'] ?? '',
        });
      } else {
        // Declined
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .update({'status': status});

        Get.snackbar(
          'Declined',
          'You have declined the request.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error updating request: $e');
      Get.snackbar('Error', 'Failed to update: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Get or create a single chat room between two users (no duplicate per request)
  Future<String> _getOrCreateChatRoom({
    required String requesterId,
    required String requesterName,
    required String requesterPhoto,
    required String acceptorId,
    required String acceptorName,
    required String acceptorPhoto,
  }) async {
    // Create deterministic chat room ID (same users = same chat room)
    final List<String> ids = [requesterId, acceptorId]..sort();
    final chatRoomId = '${ids[0]}_${ids[1]}';

    final existingRoom = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .get();

    if (!existingRoom.exists) {
      // Create new chat room
      await FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).set({
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
        'lastMessage': 'Chat started',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  /// Send notification to requester when request is accepted
  Future<void> _sendAcceptanceNotification({
    required String requesterId,
    required String acceptorName,
    required String bloodType,
    required String chatRoomId,
  }) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // Get requester's FCM token
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(requesterId)
          .get();

      final fcmToken = userDoc.data()?['fcmToken'] as String?;
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await FCMService.sendNotification(
          senderName: 'Request Accepted! ✅',
          fcmToken: fcmToken,
          msg: '$acceptorName accepted your $bloodType blood request',
          senderId: currentUserId,
          receiverId: requesterId,
          type: 'request_accepted',
          extraData: {
            'chatRoomId': chatRoomId,
            'bloodType': bloodType,
          },
        );
      }

      // Also store in Firestore for in-app notifications
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': requesterId,
        'type': 'request_accepted',
        'title': 'Request Accepted!',
        'body': '$acceptorName accepted your $bloodType blood request',
        'chatRoomId': chatRoomId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error sending acceptance notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Requests", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('Please log in to view requests'))
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('requestToUid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading requests'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Client-side sorting (no index needed)
            final requests = snapshot.data?.docs ?? [];
            requests.sort((a, b) {
              final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
              final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
              if (aTime == null || bTime == null) return 0;
              return bTime.compareTo(aTime); // Descending
            });

            if (requests.isEmpty) {
              return const Center(
                child: Text(
                  "No pending blood requests",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final data = requests[index].data() as Map<String, dynamic>;
                final requestId = requests[index].id;

                return BloodRequestCard(
                  bloodType: data['bloodType'] ?? 'N/A',
                  title: data['patientName'] ?? 'Unknown Patient',
                  hospital: data['hospital'] ?? 'Unknown Hospital',
                  date: data['date'] ?? 'N/A',
                  onAccept: () => _updateRequestStatus(requestId, 'accepted', data),
                  onDecline: () => _updateRequestStatus(requestId, 'declined', data),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
