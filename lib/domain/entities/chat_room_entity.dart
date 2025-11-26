/// Chat room entity - represents a chat room in the domain layer
class ChatRoomEntity {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastSenderId;
  final String? needId;
  final DateTime? createdAt;

  const ChatRoomEntity({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
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
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastSenderId,
    String? needId,
    DateTime? createdAt,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastSenderId: lastSenderId ?? this.lastSenderId,
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
