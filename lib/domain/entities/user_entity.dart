import 'package:cloud_firestore/cloud_firestore.dart';

/// User entity - represents a user in the domain layer
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bloodType;
  final String? city;
  final GeoPoint? location;
  final String? fcmToken;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.phoneNumber,
    this.bloodType,
    this.city,
    this.location,
    this.fcmToken,
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Copy with method for immutability
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? bloodType,
    String? city,
    GeoPoint? location,
    String? fcmToken,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      city: city ?? this.city,
      location: location ?? this.location,
      fcmToken: fcmToken ?? this.fcmToken,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email, name: $name)';
}
