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
  final _messages = <MessageEntity>[].obs;
  final _isLoading = false.obs;
  final _currentChatRoom = Rxn<ChatRoomEntity>();
  final _otherUser = Rxn<UserEntity>();

  // Message input controller
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // Getters
  List<ChatRoomEntity> get chatRooms => _chatRooms;
  List<MessageEntity> get messages => _messages;
  bool get isLoading => _isLoading.value;
  ChatRoomEntity? get currentChatRoom => _currentChatRoom.value;
  UserEntity? get otherUser => _otherUser.value;

  @override
  void onInit() {
    super.onInit();
    loadChatRooms();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Load chat rooms for current user
  void loadChatRooms() {
    _chatRepository.watchChatRooms(currentUserId).listen((rooms) {
      _chatRooms.value = rooms;
    });
  }

  /// Open a chat room and load messages
  Future<void> openChatRoom(String chatRoomId, String otherUserId) async {
    _isLoading.value = true;

    // Get chat room
    final chatResult = await _chatRepository.getChatRoomById(chatRoomId);
    chatResult.onSuccess((room) {
      _currentChatRoom.value = room;
    });

    // Get other user info
    final userResult = await _userRepository.getUserById(otherUserId);
    userResult.onSuccess((user) {
      _otherUser.value = user;
    });

    // Watch messages
    _chatRepository.watchMessages(chatRoomId).listen((msgs) {
      _messages.value = msgs;
      _scrollToBottom();
    });

    // Mark messages as read
    await _chatRepository.markMessagesAsRead(
      chatRoomId: chatRoomId,
      userId: currentUserId,
    );

    _isLoading.value = false;
  }

  /// Send a message
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || _currentChatRoom.value == null) return;

    final chatRoomId = _currentChatRoom.value!.id;
    messageController.clear();

    final result = await _chatRepository.sendMessage(
      chatRoomId: chatRoomId,
      senderId: currentUserId,
      senderName: 'User', // Would come from auth
      message: text,
    );

    result.onSuccess((message) {
      // Send push notification to other user
      if (_otherUser.value != null) {
        _notificationRepository.sendPushNotification(
          receiverId: _otherUser.value!.id,
          title: 'New Message',
          body: text,
          type: 'chat_message',
          data: {
            'chatRoomId': chatRoomId,
            'senderId': currentUserId,
          },
        );
      }
    });
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
    _currentChatRoom.value = null;
    _otherUser.value = null;
    _messages.clear();
  }
}
