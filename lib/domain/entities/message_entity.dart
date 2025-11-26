/// Message entity - represents a chat message in the domain layer
class MessageEntity {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String message;
  final String type; // text, image, etc.
  final String? imageUrl;
  final bool isRead;
  final DateTime? createdAt;

  const MessageEntity({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.type = 'text',
    this.imageUrl,
    this.isRead = false,
    this.createdAt,
  });

  /// Check if message is from current user
  bool isFromMe(String currentUserId) => senderId == currentUserId;

  /// Copy with method for immutability
  MessageEntity copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? senderName,
    String? message,
    String? type,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
