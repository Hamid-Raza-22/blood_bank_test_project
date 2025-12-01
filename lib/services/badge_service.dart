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
  /// Counts chat rooms where the user has unread messages
  /// Uses multiple strategies:
  /// 1. Check 'unreadCounts' map field
  /// 2. Check 'unread_<userId>' field
  /// 3. Count total chat rooms as fallback
  Stream<int> watchUnreadChatsCount(String userId) {
    debugPrint('BadgeService: Starting to watch unread chats for userId: $userId');
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      debugPrint('BadgeService: Got ${snapshot.docs.length} chat rooms for $userId');
      
      int unreadCount = 0;
      bool hasUnreadField = false;
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        debugPrint('BadgeService: Chat room ${doc.id} data keys: ${data.keys.toList()}');
        
        // Strategy 1: Check 'unreadCounts' map
        if (data.containsKey('unreadCounts')) {
          hasUnreadField = true;
          final unreadCounts = data['unreadCounts'] as Map<String, dynamic>? ?? {};
          final userUnread = unreadCounts[userId] as int? ?? 0;
          unreadCount += userUnread;
          debugPrint('BadgeService: unreadCounts[$userId] = $userUnread');
        }
        
        // Strategy 2: Check 'unread_<userId>' field
        final unreadKey = 'unread_$userId';
        if (data.containsKey(unreadKey)) {
          hasUnreadField = true;
          final userUnread = data[unreadKey] as int? ?? 0;
          unreadCount += userUnread;
          debugPrint('BadgeService: $unreadKey = $userUnread');
        }
      }
      
      // Strategy 3: If no unread fields exist, count chat rooms as indicator
      // (This is a fallback - shows total chats, not unread)
      if (!hasUnreadField && snapshot.docs.isNotEmpty) {
        // For now just show 0 if no unread tracking exists
        debugPrint('BadgeService: No unread tracking fields found, returning 0');
        unreadCount = 0;
      }
      
      debugPrint('BadgeService: Final unread chats count for $userId: $unreadCount');
      return unreadCount;
    }).handleError((error) {
      debugPrint('BadgeService ERROR: watchUnreadChatsCount failed: $error');
      return 0;
    });
  }

  /// Stream of unread notifications count for a user
  Stream<int> watchUnreadNotificationsCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      final count = snapshot.docs.length;
      debugPrint('BadgeService: Unread notifications count for $userId: $count');
      return count;
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
