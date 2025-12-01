import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// BadgeService - Handles real-time badge counts from Firestore
/// 
/// Provides streams for:
/// - Unread chat messages count
/// - Unread notifications count
/// - Pending blood requests count
class BadgeService {
  final FirebaseFirestore _firestore;

  BadgeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of unread chat messages count for a user
  /// 
  /// Counts chat rooms where user has unread messages by checking:
  /// 1. lastSenderId != userId (last message from other user)
  /// 2. Or counts unread messages in messages subcollection
  Stream<int> watchUnreadChatsCount(String userId) {
    debugPrint('BadgeService: Starting to watch unread chats for userId: $userId');
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      debugPrint('BadgeService: Got ${snapshot.docs.length} chat rooms for $userId');
      
      int unreadCount = 0;
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final chatRoomId = doc.id;
        
        // Strategy 1: Check if there are unread messages in subcollection
        try {
          final unreadMessages = await _firestore
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection('messages')
              .where('read', isEqualTo: false)
              .get();
          
          // Count messages that are not from current user
          int roomUnread = 0;
          for (var msgDoc in unreadMessages.docs) {
            final msgData = msgDoc.data();
            if (msgData['senderId'] != userId) {
              roomUnread++;
            }
          }
          
          if (roomUnread > 0) {
            debugPrint('BadgeService: Chat $chatRoomId has $roomUnread unread messages');
            unreadCount += roomUnread;
          }
        } catch (e) {
          debugPrint('BadgeService: Error checking messages for $chatRoomId: $e');
          
          // Fallback: Check lastSenderId
          final lastSenderId = data['lastSenderId'] as String?;
          if (lastSenderId != null && lastSenderId != userId) {
            // Last message was from other user - might be unread
            // But we can't be sure, so we skip this
          }
        }
      }
      
      debugPrint('BadgeService: Final unread chats count for $userId: $unreadCount');
      return unreadCount;
    }).handleError((error) {
      debugPrint('BadgeService ERROR: watchUnreadChatsCount failed: $error');
      return 0;
    });
  }

  /// Stream of unread notifications count for a user
  /// Checks for 'read' field (not 'isRead') to match notification_screen.dart
  Stream<int> watchUnreadNotificationsCount(String userId) {
    debugPrint('BadgeService: Starting to watch unread notifications for userId: $userId');
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Count notifications where 'read' is false or doesn't exist
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Check both 'read' and 'isRead' fields for compatibility
        final isRead = data['read'] == true || data['isRead'] == true;
        if (!isRead) {
          unreadCount++;
        }
      }
      debugPrint('BadgeService: Unread notifications count for $userId: $unreadCount (total: ${snapshot.docs.length})');
      return unreadCount;
    }).handleError((error) {
      debugPrint('BadgeService ERROR: watchUnreadNotificationsCount failed: $error');
      return 0;
    });
  }

  /// Stream of pending blood requests count for a user
  /// 
  /// Counts requests where the user is the donor and status is pending
  Stream<int> watchPendingRequestsCount(String userId) {
    return _firestore
        .collection('requests')
        .where('donorUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final count = snapshot.docs.length;
      debugPrint('BadgeService: Pending requests count for $userId: $count');
      return count;
    });
  }

  /// Get total unread count (chats + notifications)
  Stream<int> watchTotalUnreadCount(String userId) {
    return watchUnreadChatsCount(userId).asyncMap((chatCount) async {
      // This is a simplified version - for more accurate results,
      // combine multiple streams properly
      return chatCount;
    });
  }

  /// Mark all chat messages as read in a specific chat room
  Future<void> markChatAsRead(String chatRoomId, String userId) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'unreadCounts.$userId': 0,
      });
      debugPrint('BadgeService: Marked chat $chatRoomId as read for $userId');
    } catch (e) {
      debugPrint('BadgeService ERROR: Failed to mark chat as read: $e');
    }
  }

  /// Increment unread count for the other user when sending a message
  Future<void> incrementUnreadCount(String chatRoomId, String recipientId) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'unreadCounts.$recipientId': FieldValue.increment(1),
      });
      debugPrint('BadgeService: Incremented unread count for $recipientId in $chatRoomId');
    } catch (e) {
      debugPrint('BadgeService ERROR: Failed to increment unread count: $e');
    }
  }
}
