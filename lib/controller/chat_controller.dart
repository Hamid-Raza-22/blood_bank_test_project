import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../services/firebase_service.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  RxList messages = RxList([]);
  String roomId = '';

  void initChat(String otherUserId) {
    String myUid = Get.find<AuthController>().firebaseUser.value!.uid;
    final participants = [myUid, otherUserId];
    participants.sort();
    roomId = participants.join('_');
    _listenMessages();
  }

  void _listenMessages() {
    _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          messages.value = snapshot.docs;
        });
  }

  Future<void> sendMessage(String text, String otherUserId) async {
    try {
      String myUid = Get.find<AuthController>().firebaseUser.value!.uid;
      await _firestore.collection('chats').doc(roomId).set({
        'participants': [myUid, otherUserId],
      }, SetOptions(merge: true));
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add({
            'senderId': myUid,
            'text': text,
            'timestamp': FieldValue.serverTimestamp(),
          });
      // Notify other user
      String? fcmToken = await _firestore
          .collection('users')
          .doc(otherUserId)
          .get()
          .then((doc) => doc.data()?['fcmToken']);
      if (fcmToken != null) {
        await _firebaseService.sendFcmNotification(
          fcmToken,
          'New Message',
          text,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }
}
