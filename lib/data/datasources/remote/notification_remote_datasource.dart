import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/notification_entity.dart';

/// Notification remote data source interface
abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotificationsForUser(String userId);
  Future<int> getUnreadCount(String userId);
  Future<NotificationEntity> createNotification(NotificationEntity notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    Map<String, String>? data,
  });
  Stream<List<NotificationEntity>> watchNotifications(String userId);
  Stream<int> watchUnreadCount(String userId);
}

/// Notification remote data source implementation
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseMessaging messaging;

  static const String _fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/blood-bank-146c7/messages:send';
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  NotificationRemoteDataSourceImpl({
    required this.firestore,
    required this.messaging,
  });

  CollectionReference get _notificationsCollection => firestore.collection('notifications');
  CollectionReference get _usersCollection => firestore.collection('users');

  @override
  Future<List<NotificationEntity>> getNotificationsForUser(String userId) async {
    try {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .get();
      
      final notifications = query.docs.map((doc) => _notificationFromDoc(doc)).toList();
      notifications.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return notifications;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final query = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();
      return query.docs.length;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NotificationEntity> createNotification(NotificationEntity notification) async {
    try {
      final docRef = await _notificationsCollection.add({
        'userId': notification.userId,
        'title': notification.title,
        'body': notification.body,
        'type': notification.type,
        'data': notification.data,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final doc = await docRef.get();
      return _notificationFromDoc(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({'read': true});
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = firestore.batch();
      final notifications = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'read': true});
      }
      await batch.commit();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    Map<String, String>? data,
  }) async {
    try {
      // Get receiver's FCM token
      final userDoc = await _usersCollection.doc(receiverId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      final fcmToken = userData?['fcmToken'] as String?;

      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('No FCM token for user $receiverId');
        return;
      }

      final accessToken = await _getAccessToken();
      
      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'type': type,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              ...?data,
            },
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'high_importance_channel',
                'sound': 'default',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'default',
                  'badge': 1,
                },
              },
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Push notification sent successfully');
      } else {
        debugPrint('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending push notification: $e');
    }
  }

  Future<String> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      return _accessToken!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/service-account.json');
      final serviceAccount = jsonDecode(jsonString);

      final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await clientViaServiceAccount(accountCredentials, scopes);
      _accessToken = client.credentials.accessToken.data;
      _tokenExpiry = client.credentials.accessToken.expiry;

      client.close();
      return _accessToken!;
    } catch (e) {
      throw ServerException(message: 'Failed to get access token: $e');
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs.map((doc) => _notificationFromDoc(doc)).toList();
      notifications.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return notifications;
    });
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  NotificationEntity _notificationFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationEntity(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? '',
      data: data['data'] != null ? Map<String, dynamic>.from(data['data']) : null,
      isRead: data['read'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
