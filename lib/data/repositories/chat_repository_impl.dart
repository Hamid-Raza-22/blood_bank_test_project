import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_datasource.dart';

/// Chat repository implementation
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<ChatRoomEntity>> getChatRoomById(String chatRoomId) async {
    try {
      final chatRoom = await remoteDataSource.getChatRoomById(chatRoomId);
      return Result.success(chatRoom);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<ChatRoomEntity>>> getChatRoomsForUser(String userId) async {
    try {
      final chatRooms = await remoteDataSource.getChatRoomsForUser(userId);
      return Result.success(chatRooms);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<ChatRoomEntity>> createChatRoom({
    required List<String> participants,
    String? needId,
  }) async {
    try {
      final chatRoom = await remoteDataSource.createChatRoom(participants, needId);
      return Result.success(chatRoom);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<ChatRoomEntity>> getOrCreateChatRoom({
    required String userId1,
    required String userId2,
    String? needId,
  }) async {
    try {
      final chatRoom = await remoteDataSource.getOrCreateChatRoom(userId1, userId2, needId);
      return Result.success(chatRoom);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
    String type = 'text',
  }) async {
    try {
      final msg = await remoteDataSource.sendMessage(
        chatRoomId, senderId, senderName, message, type,
      );
      return Result.success(msg);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<MessageEntity>>> getMessages(String chatRoomId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatRoomId);
      return Result.success(messages);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markMessagesAsRead({
    required String chatRoomId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.markMessagesAsRead(chatRoomId, userId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<ChatRoomEntity>> watchChatRooms(String userId) {
    return remoteDataSource.watchChatRooms(userId);
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String chatRoomId) {
    return remoteDataSource.watchMessages(chatRoomId);
  }
}
