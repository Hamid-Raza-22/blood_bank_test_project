/// Chat room entity - represents a chat room in the domain layer
class ChatRoomEntity {
  final String id;
  final List<String> participants;
  final Map<String, String>? participantNames;
  final Map<String, String>? participantPhotos;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final Map<String, int>? unreadCount;
  final String? needId;
  final DateTime? createdAt;

  const ChatRoomEntity({
    required this.id,
    required this.participants,
    this.participantNames,
    this.participantPhotos,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCount,
    this.needId,
    this.createdAt,
  });

  /// Get the other participant's ID given current user ID
  String getOtherParticipantId(String currentUserId) {
    return participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  /// Copy with method for immutability
  ChatRoomEntity copyWith({
    String? id,
    List<String>? participants,
    Map<String, String>? participantNames,
    Map<String, String>? participantPhotos,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    Map<String, int>? unreadCount,
    String? needId,
    DateTime? createdAt,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      participantPhotos: participantPhotos ?? this.participantPhotos,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      needId: needId ?? this.needId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoomEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
