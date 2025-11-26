import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

/// Message Model - DTO for MessageEntity
class MessageModel extends MessageEntity {
  const MessageModel({
    required String id,
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String message,
    String type = 'text',
    String? imageUrl,
    bool isRead = false,
    DateTime? createdAt,
  }) : super(
    id: id,
    chatRoomId: chatRoomId,
    senderId: senderId,
    senderName: senderName,
    message: message,
    type: type,
    imageUrl: imageUrl,
    isRead: isRead,
    createdAt: createdAt,
  );

  /// Create from Firestore document
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      chatRoomId: data['chatRoomId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'text',
      imageUrl: data['imageUrl'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create from Map
  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'text',
      imageUrl: map['imageUrl'],
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'type': type,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isRead': isRead,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Create from entity
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatRoomId: entity.chatRoomId,
      senderId: entity.senderId,
      senderName: entity.senderName,
      message: entity.message,
      type: entity.type,
      imageUrl: entity.imageUrl,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to entity
  MessageEntity toEntity() => this;
}
