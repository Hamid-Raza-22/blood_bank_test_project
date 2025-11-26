/// Message entity - represents a chat message in the domain layer
class MessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String type; // text, image, etc.
  final bool isRead;
  final DateTime? timestamp;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.type = 'text',
    this.isRead = false,
    this.timestamp,
  });

  /// Check if message is from current user
  bool isFromMe(String currentUserId) => senderId == currentUserId;

  /// Copy with method for immutability
  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? message,
    String? type,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
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
