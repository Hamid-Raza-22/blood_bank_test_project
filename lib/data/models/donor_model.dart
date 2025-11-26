import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/donor_entity.dart';

/// Donor data transfer object - handles serialization/deserialization
class DonorModel extends DonorEntity {
  const DonorModel({
    required super.id,
    required super.name,
    required super.bloodType,
    required super.city,
    super.phoneNumber,
    super.location,
    super.isAvailable,
    super.photoUrl,
    required super.userId,
    super.lastDonation,
    super.donationCount,
    super.createdAt,
  });

  /// Create from Firestore document
  factory DonorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return DonorModel(
      id: doc.id,
      name: data['name'] ?? '',
      bloodType: data['bloodType'] ?? '',
      city: data['city'] ?? '',
      phoneNumber: data['phoneNumber'],
      location: data['location'] as GeoPoint?,
      isAvailable: data['isAvailable'] ?? true,
      photoUrl: data['photoUrl'],
      userId: data['userId'] ?? '',
      lastDonation: (data['lastDonation'] as Timestamp?)?.toDate(),
      donationCount: data['donationCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bloodType': bloodType,
      'city': city,
      'phoneNumber': phoneNumber,
      'location': location,
      'isAvailable': isAvailable,
      'photoUrl': photoUrl,
      'userId': userId,
      'lastDonation': lastDonation != null ? Timestamp.fromDate(lastDonation!) : null,
      'donationCount': donationCount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  /// Convert from entity
  factory DonorModel.fromEntity(DonorEntity entity) {
    return DonorModel(
      id: entity.id,
      name: entity.name,
      bloodType: entity.bloodType,
      city: entity.city,
      phoneNumber: entity.phoneNumber,
      location: entity.location,
      isAvailable: entity.isAvailable,
      photoUrl: entity.photoUrl,
      userId: entity.userId,
      lastDonation: entity.lastDonation,
      donationCount: entity.donationCount,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to entity
  DonorEntity toEntity() {
    return DonorEntity(
      id: id,
      name: name,
      bloodType: bloodType,
      city: city,
      phoneNumber: phoneNumber,
      location: location,
      isAvailable: isAvailable,
      photoUrl: photoUrl,
      userId: userId,
      lastDonation: lastDonation,
      donationCount: donationCount,
      createdAt: createdAt,
    );
  }
}
