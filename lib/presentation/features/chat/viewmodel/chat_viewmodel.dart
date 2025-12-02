import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/chat_room_entity.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../../domain/repositories/notification_repository.dart';
import '../../../../domain/repositories/user_repository.dart';

/// Chat ViewModel - handles chat state and logic
class ChatViewModel extends GetxController {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final String currentUserId;

  ChatViewModel({
    required ChatRepository chatRepository,
    required UserRepository userRepository,
    required NotificationRepository notificationRepository,
    required this.currentUserId,
  })  : _chatRepository = chatRepository,
        _userRepository = userRepository,
        _notificationRepository = notificationRepository;

  // Observable states
  final _chatRooms = <ChatRoomEntity>[].obs;
  final _filteredChatRooms = <ChatRoomEntity>[].obs;
  final _messages = <MessageEntity>[].obs;
  final _isLoading = false.obs;
  final _isSendingMessage = false.obs;
  final _currentChatRoom = Rxn<ChatRoomEntity>();
  final _otherUser = Rxn<UserEntity>();
  final _searchQuery = ''.obs;
  final _error = Rxn<String>();

  // Chat room info for current chat
  final _chatRoomId = ''.obs;
  final _otherUserId = ''.obs;
  final _otherUserName = 'User'.obs;
  final _otherUserPhoto = ''.obs;

  // Message input controller
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final searchController = TextEditingController();

  // Stream subscriptions
  StreamSubscription? _chatRoomsSubscription;
  StreamSubscription? _messagesSubscription;

  // Getters
  List<ChatRoomEntity> get chatRooms => _chatRooms;
  List<ChatRoomEntity> get filteredChatRooms => _filteredChatRooms;
  List<MessageEntity> get messages => _messages;
  bool get isLoading => _isLoading.value;
  bool get isSendingMessage => _isSendingMessage.value;
  ChatRoomEntity? get currentChatRoom => _currentChatRoom.value;
  UserEntity? get otherUser => _otherUser.value;
  String get searchQuery => _searchQuery.value;
  String? get error => _error.value;
  String get chatRoomId => _chatRoomId.value;
  String get otherUserId => _otherUserId.value;
  String get otherUserName => _otherUserName.value;
  String get otherUserPhoto => _otherUserPhoto.value;

  @override
  void onInit() {
    super.onInit();
    loadChatRooms();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    searchController.dispose();
    _chatRoomsSubscription?.cancel();
    _messagesSubscription?.cancel();
    super.onClose();
  }

  /// Load chat rooms for current user
  void loadChatRooms() {
    _isLoading.value = true;
    _chatRoomsSubscription?.cancel();
    _chatRoomsSubscription = _chatRepository.watchChatRooms(currentUserId).listen(
      (rooms) async {
        // Sort by last message time
        rooms.sort((a, b) {
          final aTime = a.lastMessageTime;
          final bTime = b.lastMessageTime;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        
        // Enrich rooms with user info if missing
        final enrichedRooms = await _enrichChatRoomsWithUserInfo(rooms);
        _chatRooms.value = enrichedRooms;
        _filterChatRooms();
        _isLoading.value = false;
      },
      onError: (e) {
        _error.value = 'Failed to load chats: $e';
        _isLoading.value = false;
      },
    );
  }

  /// Enrich chat rooms with user info if participant names/photos are missing
  Future<List<ChatRoomEntity>> _enrichChatRoomsWithUserInfo(List<ChatRoomEntity> rooms) async {
    final enrichedRooms = <ChatRoomEntity>[];
    
    for (final room in rooms) {
      final otherUserId = room.getOtherParticipantId(currentUserId);
      
      // Check if we already have the user info
      if (room.participantNames?[otherUserId] != null) {
        enrichedRooms.add(room);
        continue;
      }
      
      // Fetch user info
      final userResult = await _userRepository.getUserById(otherUserId);
      final user = userResult.fold(
        onSuccess: (u) => u,
        onFailure: (_) => null,
      );
      
      if (user != null) {
        final updatedRoom = room.copyWith(
          participantNames: {
            ...(room.participantNames ?? {}),
            otherUserId: user.name ?? 'User',
          },
          participantPhotos: {
            ...(room.participantPhotos ?? {}),
            otherUserId: user.photoUrl ?? '',
          },
        );
        enrichedRooms.add(updatedRoom);
      } else {
        enrichedRooms.add(room);
      }
    }
    
    return enrichedRooms;
  }

  /// Filter chat rooms based on search query
  void _filterChatRooms() {
    if (_searchQuery.value.isEmpty) {
      _filteredChatRooms.value = _chatRooms;
    } else {
      final query = _searchQuery.value.toLowerCase();
      _filteredChatRooms.value = _chatRooms.where((room) {
        final otherUserId = room.getOtherParticipantId(currentUserId);
        final name = room.participantNames?[otherUserId]?.toLowerCase() ?? '';
        final lastMessage = room.lastMessage?.toLowerCase() ?? '';
        return name.contains(query) || lastMessage.contains(query);
      }).toList();
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    _filterChatRooms();
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    _searchQuery.value = '';
    _filterChatRooms();
  }

  /// Initialize chat screen with arguments
  void initChatScreen(Map<String, dynamic>? args) {
    _chatRoomId.value = args?['chatRoomId'] ?? '';
    _otherUserId.value = args?['otherUserId'] ?? '';
    _otherUserName.value = args?['otherUserName'] ?? 'User';
    _otherUserPhoto.value = args?['otherUserPhoto'] ?? '';
    
    if (_chatRoomId.value.isNotEmpty) {
      openChatRoom(_chatRoomId.value, _otherUserId.value);
    }
  }

  /// Open a chat room and load messages
  Future<void> openChatRoom(String chatRoomId, String otherUserId) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      // Get chat room
      final chatResult = await _chatRepository.getChatRoomById(chatRoomId);
      chatResult.onSuccess((room) {
        _currentChatRoom.value = room;
      });

      // Get other user info
      final userResult = await _userRepository.getUserById(otherUserId);
      userResult.onSuccess((user) {
        _otherUser.value = user;
        _otherUserName.value = user.name ?? 'User';
        _otherUserPhoto.value = user.photoUrl ?? '';
      });

      // Watch messages
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatRepository.watchMessages(chatRoomId).listen(
        (msgs) {
          _messages.value = msgs;
          _scrollToBottom();
        },
        onError: (e) {
          _error.value = 'Error loading messages: $e';
        },
      );

      // Mark messages as read
      await markMessagesAsRead();
    } catch (e) {
      _error.value = 'Failed to open chat: $e';
    }

    _isLoading.value = false;
  }

  /// Mark all unread messages from other user as read
  Future<void> markMessagesAsRead() async {
    if (_chatRoomId.value.isEmpty) return;
    
    try {
      await _chatRepository.markMessagesAsRead(
        chatRoomId: _chatRoomId.value,
        userId: currentUserId,
      );
    } catch (e) {
      debugPrint('ChatViewModel: Failed to mark messages as read: $e');
    }
  }

  /// Send a message
  Future<void> sendMessage({String? senderName}) async {
    final text = messageController.text.trim();
    if (text.isEmpty || _chatRoomId.value.isEmpty) return;

    _isSendingMessage.value = true;
    final chatRoomIdValue = _chatRoomId.value;
    messageController.clear();

    try {
      final result = await _chatRepository.sendMessage(
        chatRoomId: chatRoomIdValue,
        senderId: currentUserId,
        senderName: senderName ?? 'User',
        message: text,
      );

      result.onSuccess((message) {
        // Send push notification to other user
        if (_otherUserId.value.isNotEmpty) {
          _notificationRepository.sendPushNotification(
            receiverId: _otherUserId.value,
            title: senderName ?? 'New Message',
            body: text,
            type: 'chat_message',
            data: {
              'chatRoomId': chatRoomIdValue,
              'senderId': currentUserId,
            },
          );
        }
        _scrollToBottom();
      });

      result.onFailure((failure) {
        _error.value = 'Failed to send message';
        Get.snackbar('Error', 'Failed to send message',
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    } catch (e) {
      _error.value = 'Failed to send message: $e';
      Get.snackbar('Error', 'Failed to send message',
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    _isSendingMessage.value = false;
  }

  /// Create or get existing chat room with another user
  Future<String?> getOrCreateChatRoom(String otherUserId, {String? needId}) async {
    final result = await _chatRepository.getOrCreateChatRoom(
      userId1: currentUserId,
      userId2: otherUserId,
      needId: needId,
    );

    return result.fold(
      onSuccess: (room) => room.id,
      onFailure: (_) => null,
    );
  }

  /// Get other user info for a chat room
  Future<UserEntity?> getOtherUserInfo(ChatRoomEntity chatRoom) async {
    final otherUserId = chatRoom.getOtherParticipantId(currentUserId);
    final result = await _userRepository.getUserById(otherUserId);
    return result.fold(
      onSuccess: (user) => user,
      onFailure: (_) => null,
    );
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void closeChatRoom() {
    _messagesSubscription?.cancel();
    _currentChatRoom.value = null;
    _otherUser.value = null;
    _messages.clear();
    _chatRoomId.value = '';
    _otherUserId.value = '';
    _otherUserName.value = 'User';
    _otherUserPhoto.value = '';
    messageController.clear();
  }

  /// Navigate to chat screen
  void navigateToChat(ChatRoomEntity chatRoom) {
    final otherUserId = chatRoom.getOtherParticipantId(currentUserId);
    final otherUserName = chatRoom.participantNames?[otherUserId] ?? 'User';
    final otherUserPhoto = chatRoom.participantPhotos?[otherUserId] ?? '';

    Get.toNamed('/chat', arguments: {
      'chatRoomId': chatRoom.id,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserPhoto': otherUserPhoto,
    });
  }

  /// Format time for display
  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'now';
    }
  }

  /// Format message time
  String formatMessageTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  /// Check if message is from current user
  bool isMessageFromMe(MessageEntity message) {
    return message.senderId == currentUserId;
  }

  /// Get other user name for a chat room
  String getOtherUserNameForRoom(ChatRoomEntity room) {
    final otherUserId = room.getOtherParticipantId(currentUserId);
    return room.participantNames?[otherUserId] ?? 'User';
  }

  /// Get other user photo for a chat room
  String getOtherUserPhotoForRoom(ChatRoomEntity room) {
    final otherUserId = room.getOtherParticipantId(currentUserId);
    return room.participantPhotos?[otherUserId] ?? '';
  }

  /// Show coming soon snackbar for features not implemented
  void showComingSoon(String feature) {
    Get.snackbar('Coming Soon', '$feature feature coming soon!');
  }
}
