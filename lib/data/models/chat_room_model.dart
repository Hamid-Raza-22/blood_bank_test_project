import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_room_entity.dart';

/// ChatRoom Model - DTO for ChatRoomEntity
class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required String id,
    required List<String> participants,
    Map<String, String>? participantNames,
    Map<String, String>? participantPhotos,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    Map<String, int>? unreadCount,
    String? needId,
    DateTime? createdAt,
  }) : super(
    id: id,
    participants: participants,
    participantNames: participantNames,
    participantPhotos: participantPhotos,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime,
    lastMessageSenderId: lastMessageSenderId,
    unreadCount: unreadCount,
    needId: needId,
    createdAt: createdAt,
  );

  /// Create from Firestore document
  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
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

  /// Create from Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatRoomModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: map['participantNames'] != null
          ? Map<String, String>.from(map['participantNames'])
          : null,
      participantPhotos: map['participantPhotos'] != null
          ? Map<String, String>.from(map['participantPhotos'])
          : null,
      lastMessage: map['lastMessage'],
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessageSenderId: map['lastMessageSenderId'],
      unreadCount: map['unreadCount'] != null
          ? Map<String, int>.from(map['unreadCount'])
          : null,
      needId: map['needId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      if (participantNames != null) 'participantNames': participantNames,
      if (participantPhotos != null) 'participantPhotos': participantPhotos,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': Timestamp.fromDate(lastMessageTime!),
      if (lastMessageSenderId != null) 'lastMessageSenderId': lastMessageSenderId,
      if (unreadCount != null) 'unreadCount': unreadCount,
      if (needId != null) 'needId': needId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Create from entity
  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      participants: entity.participants,
      participantNames: entity.participantNames,
      participantPhotos: entity.participantPhotos,
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
      lastMessageSenderId: entity.lastMessageSenderId,
      unreadCount: entity.unreadCount,
      needId: entity.needId,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to entity
  ChatRoomEntity toEntity() => this;
}
