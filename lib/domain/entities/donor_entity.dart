import 'package:cloud_firestore/cloud_firestore.dart';

/// Donor entity - represents a blood donor in the domain layer
class DonorEntity {
  final String id;
  final String name;
  final String bloodType;
  final String city;
  final String? phoneNumber;
  final GeoPoint? location;
  final bool isAvailable;
  final String? photoUrl;
  final String userId;
  final DateTime? lastDonation;
  final int donationCount;
  final DateTime? createdAt;

  const DonorEntity({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.city,
    this.phoneNumber,
    this.location,
    this.isAvailable = true,
    this.photoUrl,
    required this.userId,
    this.lastDonation,
    this.donationCount = 0,
    this.createdAt,
  });

  /// Copy with method for immutability
  DonorEntity copyWith({
    String? id,
    String? name,
    String? bloodType,
    String? city,
    String? phoneNumber,
    GeoPoint? location,
    bool? isAvailable,
    String? photoUrl,
    String? userId,
    DateTime? lastDonation,
    int? donationCount,
    DateTime? createdAt,
  }) {
    return DonorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      bloodType: bloodType ?? this.bloodType,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      photoUrl: photoUrl ?? this.photoUrl,
      userId: userId ?? this.userId,
      lastDonation: lastDonation ?? this.lastDonation,
      donationCount: donationCount ?? this.donationCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DonorEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
