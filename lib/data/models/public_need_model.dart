import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/public_need_entity.dart';

/// PublicNeed Model - DTO for PublicNeedEntity
class PublicNeedModel extends PublicNeedEntity {
  const PublicNeedModel({
    required String id,
    required String requesterId,
    required String requesterName,
    String? requesterPhoto,
    required String bloodType,
    int unitsNeeded = 1,
    String urgency = 'normal',
    String? hospital,
    String? city,
    String? notes,
    String status = 'pending',
    String? acceptedBy,
    String? chatRoomId,
    DateTime? createdAt,
    DateTime? acceptedAt,
  }) : super(
    id: id,
    requesterId: requesterId,
    requesterName: requesterName,
    requesterPhoto: requesterPhoto,
    bloodType: bloodType,
    unitsNeeded: unitsNeeded,
    urgency: urgency,
    hospital: hospital,
    city: city,
    notes: notes,
    status: status,
    acceptedBy: acceptedBy,
    chatRoomId: chatRoomId,
    createdAt: createdAt,
    acceptedAt: acceptedAt,
  );

  /// Create from Firestore document
  factory PublicNeedModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PublicNeedModel(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      requesterPhoto: data['requesterPhoto'],
      bloodType: data['bloodType'] ?? '',
      unitsNeeded: data['unitsNeeded'] ?? 1,
      urgency: data['urgency'] ?? 'normal',
      hospital: data['hospital'],
      city: data['city'],
      notes: data['notes'],
      status: data['status'] ?? 'pending',
      acceptedBy: data['acceptedBy'],
      chatRoomId: data['chatRoomId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      acceptedAt: (data['acceptedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create from Map
  factory PublicNeedModel.fromMap(Map<String, dynamic> map, String id) {
    return PublicNeedModel(
      id: id,
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      requesterPhoto: map['requesterPhoto'],
      bloodType: map['bloodType'] ?? '',
      unitsNeeded: map['unitsNeeded'] ?? 1,
      urgency: map['urgency'] ?? 'normal',
      hospital: map['hospital'],
      city: map['city'],
      notes: map['notes'],
      status: map['status'] ?? 'pending',
      acceptedBy: map['acceptedBy'],
      chatRoomId: map['chatRoomId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      acceptedAt: (map['acceptedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'requesterId': requesterId,
      'requesterName': requesterName,
      if (requesterPhoto != null) 'requesterPhoto': requesterPhoto,
      'bloodType': bloodType,
      'unitsNeeded': unitsNeeded,
      'urgency': urgency,
      if (hospital != null) 'hospital': hospital,
      if (city != null) 'city': city,
      if (notes != null) 'notes': notes,
      'status': status,
      if (acceptedBy != null) 'acceptedBy': acceptedBy,
      if (chatRoomId != null) 'chatRoomId': chatRoomId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      if (acceptedAt != null) 'acceptedAt': Timestamp.fromDate(acceptedAt!),
    };
  }

  /// Create from entity
  factory PublicNeedModel.fromEntity(PublicNeedEntity entity) {
    return PublicNeedModel(
      id: entity.id,
      requesterId: entity.requesterId,
      requesterName: entity.requesterName,
      requesterPhoto: entity.requesterPhoto,
      bloodType: entity.bloodType,
      unitsNeeded: entity.unitsNeeded,
      urgency: entity.urgency,
      hospital: entity.hospital,
      city: entity.city,
      notes: entity.notes,
      status: entity.status,
      acceptedBy: entity.acceptedBy,
      chatRoomId: entity.chatRoomId,
      createdAt: entity.createdAt,
      acceptedAt: entity.acceptedAt,
    );
  }

  /// Convert to entity
  PublicNeedEntity toEntity() => this;
}
