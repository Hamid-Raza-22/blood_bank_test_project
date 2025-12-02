import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/chat_room_entity.dart';
import '../../../domain/entities/message_entity.dart';

/// Chat remote data source interface
abstract class ChatRemoteDataSource {
  Future<ChatRoomEntity> getChatRoomById(String chatRoomId);
  Future<List<ChatRoomEntity>> getChatRoomsForUser(String userId);
  Future<ChatRoomEntity> createChatRoom(List<String> participants, String? needId);
  Future<ChatRoomEntity> getOrCreateChatRoom(String userId1, String userId2, String? needId);
  Future<MessageEntity> sendMessage(String chatRoomId, String senderId, String senderName, String message, String type);
  Future<List<MessageEntity>> getMessages(String chatRoomId);
  Future<void> markMessagesAsRead(String chatRoomId, String userId);
  Stream<List<ChatRoomEntity>> watchChatRooms(String userId);
  Stream<List<MessageEntity>> watchMessages(String chatRoomId);
}

/// Chat remote data source implementation
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _chatRoomsCollection => firestore.collection('chat_rooms');

  @override
  Future<ChatRoomEntity> getChatRoomById(String chatRoomId) async {
    try {
      final doc = await _chatRoomsCollection.doc(chatRoomId).get();
      if (!doc.exists) {
        throw const NotFoundException(message: 'Chat room not found');
      }
      return _chatRoomFromDoc(doc);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChatRoomEntity>> getChatRoomsForUser(String userId) async {
    try {
      final query = await _chatRoomsCollection
          .where('participants', arrayContains: userId)
          .get();
      return query.docs.map((doc) => _chatRoomFromDoc(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChatRoomEntity> createChatRoom(List<String> participants, String? needId) async {
    try {
      final docRef = await _chatRoomsCollection.add({
        'participants': participants,
        'needId': needId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final doc = await docRef.get();
      return _chatRoomFromDoc(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ChatRoomEntity> getOrCreateChatRoom(String userId1, String userId2, String? needId) async {
    try {
      // Create deterministic chat room ID (same users = same chat room)
      final List<String> ids = [userId1, userId2]..sort();
      final chatRoomId = '${ids[0]}_${ids[1]}';

      // Check if chat room already exists
      final existingDoc = await _chatRoomsCollection.doc(chatRoomId).get();
      
      if (existingDoc.exists) {
        return _chatRoomFromDoc(existingDoc);
      }

      // Create new chat room with deterministic ID
      await _chatRoomsCollection.doc(chatRoomId).set({
        'participants': [userId1, userId2],
        'needId': needId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await _chatRoomsCollection.doc(chatRoomId).get();
      return _chatRoomFromDoc(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MessageEntity> sendMessage(String chatRoomId, String senderId, String senderName, String message, String type) async {
    try {
      final messagesCollection = _chatRoomsCollection.doc(chatRoomId).collection('messages');
      
      final docRef = await messagesCollection.add({
        'chatRoomId': chatRoomId,
        'senderId': senderId,
        'senderName': senderName,
        'message': message,
        'type': type,
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Get chat room to find other participant
      final chatRoomDoc = await _chatRoomsCollection.doc(chatRoomId).get();
      final participants = List<String>.from((chatRoomDoc.data() as Map)['participants'] ?? []);
      final otherUserId = participants.firstWhere((id) => id != senderId, orElse: () => '');

      // Update chat room's last message and increment unread count for other user
      await _chatRoomsCollection.doc(chatRoomId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
        'unreadCount.$otherUserId': FieldValue.increment(1),
      });

      final doc = await docRef.get();
      return _messageFromDoc(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MessageEntity>> getMessages(String chatRoomId) async {
    try {
      final query = await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();
      return query.docs.map((doc) => _messageFromDoc(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      final batch = firestore.batch();
      final messages = await _chatRoomsCollection
          .doc(chatRoomId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in messages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Reset unread count for this user
      await _chatRoomsCollection.doc(chatRoomId).update({
        'unreadCount.$userId': 0,
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<ChatRoomEntity>> watchChatRooms(String userId) {
    return _chatRoomsCollection
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      final chatRooms = snapshot.docs.map((doc) => _chatRoomFromDoc(doc)).toList();
      // Sort client-side by lastMessageTime
      chatRooms.sort((a, b) {
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });
      return chatRooms;
    });
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String chatRoomId) {
    return _chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) => _messageFromDoc(doc)).toList();
      // Sort client-side by createdAt
      messages.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return a.createdAt!.compareTo(b.createdAt!);
      });
      return messages;
    });
  }

  ChatRoomEntity _chatRoomFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomEntity(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: data['participantNames'] != null
          ? Map<String, String>.from(data['participantNames'])
          : null,
      participantPhotos: data['participantPhotos'] != null
          ? Map<String, String>.from(data['participantPhotos'])
          : null,
      lastMessage: data['lastMessage'],
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessageSenderId: data['lastMessageSenderId'],
      unreadCount: data['unreadCount'] != null
          ? Map<String, int>.from(data['unreadCount'])
          : null,
      needId: data['needId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  MessageEntity _messageFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageEntity(
      id: doc.id,
      chatRoomId: data['chatRoomId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'text',
      imageUrl: data['imageUrl'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}
