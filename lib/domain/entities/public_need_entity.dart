/// Public Need entity - represents a blood request in the domain layer
class PublicNeedEntity {
  final String id;
  final String requesterId;
  final String requesterName;
  final String? requesterPhoto;
  final String bloodType;
  final String status; // pending, accepted, completed, cancelled
  final int unitsNeeded;
  final String urgency; // normal, urgent, critical
  final String? hospital;
  final String? city;
  final String? notes;
  final String? acceptedBy;
  final String? chatRoomId;
  final DateTime? createdAt;
  final DateTime? acceptedAt;

  const PublicNeedEntity({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    this.requesterPhoto,
    required this.bloodType,
    this.status = 'pending',
    this.unitsNeeded = 1,
    this.urgency = 'normal',
    this.hospital,
    this.city,
    this.notes,
    this.acceptedBy,
    this.chatRoomId,
    this.createdAt,
    this.acceptedAt,
  });

  /// Check if current user is the requester
  bool isMyRequest(String currentUserId) => requesterId == currentUserId;

  /// Check if request is still pending
  bool get isPending => status == 'pending';

  /// Check if request is accepted
  bool get isAccepted => status == 'accepted';

  /// Copy with method for immutability
  PublicNeedEntity copyWith({
    String? id,
    String? requesterId,
    String? requesterName,
    String? requesterPhoto,
    String? bloodType,
    String? status,
    int? unitsNeeded,
    String? urgency,
    String? hospital,
    String? city,
    String? notes,
    String? acceptedBy,
    String? chatRoomId,
    DateTime? createdAt,
    DateTime? acceptedAt,
  }) {
    return PublicNeedEntity(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterName: requesterName ?? this.requesterName,
      requesterPhoto: requesterPhoto ?? this.requesterPhoto,
      bloodType: bloodType ?? this.bloodType,
      status: status ?? this.status,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      urgency: urgency ?? this.urgency,
      hospital: hospital ?? this.hospital,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PublicNeedEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
