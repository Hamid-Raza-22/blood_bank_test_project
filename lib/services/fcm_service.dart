import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// FCM Service using HTTP v1 API
/// https://fcm.googleapis.com/v1/projects/{project-id}/messages:send
class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  // Firebase Project ID
  static const String _projectId = 'blood-bank-146c7';
  static String get _fcmEndpoint => 
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  // Cached access token
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  /// Get OAuth2 Access Token from Service Account
  static Future<String> getAccessToken() async {
    // Return cached token if still valid
    if (_accessToken != null && 
        _tokenExpiry != null && 
        DateTime.now().isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      return _accessToken!;
    }

    try {
      // Load service account JSON from assets
      final String jsonString = await rootBundle.loadString('assets/service-account.json');
      final serviceAccount = jsonDecode(jsonString);

      final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await clientViaServiceAccount(accountCredentials, scopes);
      _accessToken = client.credentials.accessToken.data;
      _tokenExpiry = client.credentials.accessToken.expiry;

      client.close();
      debugPrint('✅ FCM Access Token obtained successfully');
      return _accessToken!;
    } catch (e) {
      debugPrint('❌ Error getting access token: $e');
      rethrow;
    }
  }

  /// Main notification sending function (like your working code)
  static Future<void> sendNotification({
    required String senderName,
    required String fcmToken,
    required String msg,
    String? senderId,
    String? senderImage,
    required String receiverId,
    String? type,
    Map<String, String>? extraData,
  }) async {
    try {
      if (fcmToken.isEmpty) {
        debugPrint('⚠️ Cannot send notification: Empty FCM token');
        return;
      }

      if (receiverId.isEmpty) {
        debugPrint('⚠️ Cannot send notification: Empty receiver ID');
        return;
      }

      // Verify receiver exists and has valid token
      final receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      if (!receiverDoc.exists) {
        debugPrint('⚠️ Receiver $receiverId does not exist. Aborting notification.');
        return;
      }

      final storedToken = receiverDoc.data()?['fcmToken'];
      if (storedToken == null || storedToken != fcmToken) {
        debugPrint('⚠️ FCM token mismatch for receiver $receiverId');
        return;
      }

      // Get access token
      String serverTokenKey = await getAccessToken();
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> message = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": senderName,
            "body": msg,
          },
          "data": {
            "type": type ?? "chat",
            "senderId": senderId ?? '',
            "senderName": senderName,
            "senderImage": senderImage ?? '',
            "receiverId": receiverId,
            "timestamp": currentTimestamp,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            ...?extraData,
          },
          "android": {
            "priority": "high",
            "notification": {
              "channel_id": "blood_bank_channel",
              "sound": "default",
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "sound": "default",
                "badge": 1
              }
            }
          }
        }
      };

      http.Response res = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverTokenKey',
        },
        body: jsonEncode(message),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint('✅ Notification sent successfully to user: $receiverId');
      } else {
        debugPrint('❌ Failed to send notification: ${res.body}');

        // Handle UNREGISTERED token error
        if (res.body.contains('UNREGISTERED')) {
          debugPrint('🗑️ Removing unregistered FCM token for user $receiverId');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .update({'fcmToken': FieldValue.delete()});
        }
      }
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
    }
  }

  // ============ HELPER METHODS ============

  /// Send notification for new blood request to all users
  static Future<void> sendNewNeedNotification({
    required String needId,
    required String requesterName,
    required String bloodType,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (final userDoc in usersSnapshot.docs) {
      if (userDoc.id == currentUserId) continue;

      final fcmToken = userDoc.data()['fcmToken'] as String?;
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await sendNotification(
          senderName: 'New Blood Request 🩸',
          fcmToken: fcmToken,
          msg: '$requesterName needs $bloodType blood urgently!',
          senderId: currentUserId,
          receiverId: userDoc.id,
          type: 'new_need',
          extraData: {
            'needId': needId,
            'bloodType': bloodType,
          },
        );
      }
    }
  }

  /// Send notification when request is accepted
  static Future<void> sendAcceptanceNotification({
    required String requesterId,
    required String acceptorName,
    required String bloodType,
    required String chatRoomId,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(requesterId)
        .get();

    final fcmToken = userDoc.data()?['fcmToken'] as String?;
    if (fcmToken != null && fcmToken.isNotEmpty) {
      await sendNotification(
        senderName: 'Request Accepted! ✅',
        fcmToken: fcmToken,
        msg: '$acceptorName accepted your $bloodType blood request',
        senderId: currentUserId,
        receiverId: requesterId,
        type: 'need_accepted',
        extraData: {
          'chatRoomId': chatRoomId,
          'bloodType': bloodType,
        },
      );
    }
  }

  /// Send chat message notification
  static Future<void> sendChatNotification({
    required String receiverId,
    required String senderName,
    required String message,
    required String chatRoomId,
    String? senderPhoto,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    final fcmToken = userDoc.data()?['fcmToken'] as String?;
    if (fcmToken != null && fcmToken.isNotEmpty) {
      await sendNotification(
        senderName: senderName,
        fcmToken: fcmToken,
        msg: message,
        senderId: currentUserId,
        senderImage: senderPhoto,
        receiverId: receiverId,
        type: 'chat_message',
        extraData: {
          'chatRoomId': chatRoomId,
        },
      );
    }
  }
}
