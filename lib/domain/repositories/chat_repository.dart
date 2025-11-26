import '../../core/utils/result.dart';
import '../entities/chat_room_entity.dart';
import '../entities/message_entity.dart';

/// Chat repository interface - defines the contract for chat operations
abstract class ChatRepository {
  /// Get chat room by ID
  Future<Result<ChatRoomEntity>> getChatRoomById(String chatRoomId);

  /// Get chat rooms for user
  Future<Result<List<ChatRoomEntity>>> getChatRoomsForUser(String userId);

  /// Create chat room
  Future<Result<ChatRoomEntity>> createChatRoom({
    required List<String> participants,
    String? needId,
  });

  /// Get or create chat room between two users
  Future<Result<ChatRoomEntity>> getOrCreateChatRoom({
    required String userId1,
    required String userId2,
    String? needId,
  });

  /// Send message
  Future<Result<MessageEntity>> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
    String type = 'text',
  });

  /// Get messages for chat room
  Future<Result<List<MessageEntity>>> getMessages(String chatRoomId);

  /// Mark messages as read
  Future<Result<void>> markMessagesAsRead({
    required String chatRoomId,
    required String userId,
  });

  /// Stream chat rooms
  Stream<List<ChatRoomEntity>> watchChatRooms(String userId);

  /// Stream messages
  Stream<List<MessageEntity>> watchMessages(String chatRoomId);
}
