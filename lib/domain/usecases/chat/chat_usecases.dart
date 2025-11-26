import '../../../core/utils/result.dart';
import '../../entities/chat_room_entity.dart';
import '../../entities/message_entity.dart';
import '../../repositories/chat_repository.dart';
import '../base_usecase.dart';

/// Get or Create Chat Room Use Case
class GetOrCreateChatRoomUseCase implements UseCase<ChatRoomEntity, ChatRoomParams> {
  final ChatRepository repository;

  GetOrCreateChatRoomUseCase({required this.repository});

  @override
  Future<Result<ChatRoomEntity>> call(ChatRoomParams params) {
    return repository.getOrCreateChatRoom(
      userId1: params.userId1,
      userId2: params.userId2,
      needId: params.needId,
    );
  }
}

class ChatRoomParams {
  final String userId1;
  final String userId2;
  final String? needId;
  ChatRoomParams({required this.userId1, required this.userId2, this.needId});
}

/// Send Message Use Case
class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  Future<Result<MessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(
      chatRoomId: params.chatRoomId,
      senderId: params.senderId,
      senderName: params.senderName,
      message: params.message,
      type: params.type,
    );
  }
}

class SendMessageParams {
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String message;
  final String type;
  final String? imageUrl;

  SendMessageParams({
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.type = 'text',
    this.imageUrl,
  });
}

/// Watch Chat Rooms Stream Use Case
class WatchChatRoomsUseCase implements StreamUseCase<List<ChatRoomEntity>, String> {
  final ChatRepository repository;

  WatchChatRoomsUseCase({required this.repository});

  @override
  Stream<List<ChatRoomEntity>> call(String userId) {
    return repository.watchChatRooms(userId);
  }
}

/// Watch Messages Stream Use Case
class WatchMessagesUseCase implements StreamUseCase<List<MessageEntity>, String> {
  final ChatRepository repository;

  WatchMessagesUseCase({required this.repository});

  @override
  Stream<List<MessageEntity>> call(String chatRoomId) {
    return repository.watchMessages(chatRoomId);
  }
}

/// Mark Messages as Read Use Case
class MarkMessagesAsReadUseCase implements UseCase<void, MarkReadParams> {
  final ChatRepository repository;

  MarkMessagesAsReadUseCase({required this.repository});

  @override
  Future<Result<void>> call(MarkReadParams params) {
    return repository.markMessagesAsRead(
      chatRoomId: params.chatRoomId,
      userId: params.userId,
    );
  }
}

class MarkReadParams {
  final String chatRoomId;
  final String userId;
  MarkReadParams({required this.chatRoomId, required this.userId});
}
