import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/badge_service.dart';

/// BadgeController - Manages badge counts globally across the app
/// 
/// This controller:
/// - Listens to real-time Firestore updates
/// - Provides reactive badge counts for UI
/// - Automatically updates when user logs in/out
class BadgeController extends GetxController {
  static BadgeController get to => Get.find();

  final BadgeService _badgeService;
  
  // Stream subscriptions
  StreamSubscription? _chatSubscription;
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _requestSubscription;
  StreamSubscription? _authSubscription;

  // Observable badge counts
  final _unreadChatsCount = 0.obs;
  final _unreadNotificationsCount = 0.obs;
  final _pendingRequestsCount = 0.obs;

  BadgeController({BadgeService? badgeService})
      : _badgeService = badgeService ?? BadgeService();

  // Getters
  int get unreadChatsCount => _unreadChatsCount.value;
  int get unreadNotificationsCount => _unreadNotificationsCount.value;
  int get pendingRequestsCount => _pendingRequestsCount.value;
  
  /// Total unread count (chats + notifications)
  int get totalUnreadCount => _unreadChatsCount.value + _unreadNotificationsCount.value;

  /// Check if there are any unread items
  bool get hasUnreadChats => _unreadChatsCount.value > 0;
  bool get hasUnreadNotifications => _unreadNotificationsCount.value > 0;
  bool get hasPendingRequests => _pendingRequestsCount.value > 0;

  @override
  void onInit() {
    super.onInit();
    debugPrint('BadgeController: onInit called');
    _listenToAuthChanges();
  }

  @override
  void onClose() {
    _cancelSubscriptions();
    super.onClose();
  }

  /// Listen to auth state changes and initialize/clear badges accordingly
  void _listenToAuthChanges() {
    debugPrint('BadgeController: Setting up auth state listener');
    
    // Check current user immediately on init
    final currentUser = FirebaseAuth.instance.currentUser;
    debugPrint('BadgeController: Current user on init: ${currentUser?.uid ?? "null"}');
    if (currentUser != null) {
      debugPrint('BadgeController: User already logged in, starting badge streams for ${currentUser.uid}');
      _startListening(currentUser.uid);
    }
    
    // Listen to future auth changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('BadgeController: Auth state changed - user: ${user?.uid ?? "null"}');
      if (user != null) {
        debugPrint('BadgeController: User logged in, starting badge streams for ${user.uid}');
        _startListening(user.uid);
      } else {
        debugPrint('BadgeController: User logged out, clearing badges');
        _clearBadges();
        _cancelBadgeSubscriptions();
      }
    });
  }

  /// Start listening to badge count streams
  void _startListening(String userId) {
    // Cancel existing subscriptions first
    _cancelBadgeSubscriptions();

    // Listen to unread chats
    _chatSubscription = _badgeService.watchUnreadChatsCount(userId).listen(
      (count) {
        _unreadChatsCount.value = count;
        debugPrint('BadgeController: Chats count updated: $count');
      },
      onError: (e) => debugPrint('BadgeController ERROR: Chat stream error: $e'),
    );

    // Listen to unread notifications
    _notificationSubscription = _badgeService.watchUnreadNotificationsCount(userId).listen(
      (count) {
        _unreadNotificationsCount.value = count;
        debugPrint('BadgeController: Notifications count updated: $count');
      },
      onError: (e) => debugPrint('BadgeController ERROR: Notification stream error: $e'),
    );

    // Listen to pending requests
    _requestSubscription = _badgeService.watchPendingRequestsCount(userId).listen(
      (count) {
        _pendingRequestsCount.value = count;
        debugPrint('BadgeController: Requests count updated: $count');
      },
      onError: (e) => debugPrint('BadgeController ERROR: Request stream error: $e'),
    );
  }

  /// Clear all badge counts
  void _clearBadges() {
    _unreadChatsCount.value = 0;
    _unreadNotificationsCount.value = 0;
    _pendingRequestsCount.value = 0;
  }

  /// Cancel badge subscriptions (not auth)
  void _cancelBadgeSubscriptions() {
    _chatSubscription?.cancel();
    _notificationSubscription?.cancel();
    _requestSubscription?.cancel();
  }

  /// Cancel all subscriptions
  void _cancelSubscriptions() {
    _cancelBadgeSubscriptions();
    _authSubscription?.cancel();
  }

  /// Manually refresh badge counts
  @override
  void refresh() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _startListening(currentUser.uid);
    }
  }

  /// Mark chats as read (call when opening chat screen)
  Future<void> markChatsAsRead(String chatRoomId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _badgeService.markChatAsRead(chatRoomId, userId);
    }
  }

  /// Format badge count for display (e.g., 99+ for large numbers)
  String formatBadgeCount(int count) {
    if (count <= 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }
}
