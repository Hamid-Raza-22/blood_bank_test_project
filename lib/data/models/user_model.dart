import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// User data transfer object - handles serialization/deserialization
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.phoneNumber,
    super.bloodType,
    super.city,
    super.location,
    super.fcmToken,
    super.isAvailable,
    super.createdAt,
    super.updatedAt,
  });

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      bloodType: data['bloodType'],
      city: data['city'],
      location: data['location'] as GeoPoint?,
      fcmToken: data['fcmToken'],
      isAvailable: data['isAvailable'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create from map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      bloodType: map['bloodType'],
      city: map['city'],
      location: map['location'] as GeoPoint?,
      fcmToken: map['fcmToken'],
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'city': city,
      'location': location,
      'fcmToken': fcmToken,
      'isAvailable': isAvailable,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      bloodType: entity.bloodType,
      city: entity.city,
      location: entity.location,
      fcmToken: entity.fcmToken,
      isAvailable: entity.isAvailable,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      bloodType: bloodType,
      city: city,
      location: location,
      fcmToken: fcmToken,
      isAvailable: isAvailable,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
