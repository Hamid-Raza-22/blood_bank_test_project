import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

/// Notification Model - DTO for NotificationEntity
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    bool isRead = false,
    DateTime? createdAt,
  }) : super(
    id: id,
    userId: userId,
    title: title,
    body: body,
    type: type,
    data: data,
    isRead: isRead,
    createdAt: createdAt,
  );

  /// Create from Firestore document
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? 'general',
      data: data['data'] != null ? Map<String, dynamic>.from(data['data']) : null,
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? 'general',
      data: map['data'] != null ? Map<String, dynamic>.from(map['data']) : null,
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      if (data != null) 'data': data,
      'isRead': isRead,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Create from entity
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      data: entity.data,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to entity
  NotificationEntity toEntity() => this;
}
