import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String userId;
  final String? donorId;
  final String patientName;
  final String bloodType;
  final String hospital;
  final String disease;
  final String contact;
  final int units;
  final GeoPoint? location;
  final String date;
  final String status;
  final DateTime? createdAt;

  RequestModel({
    required this.id,
    required this.userId,
    this.donorId,
    required this.patientName,
    required this.bloodType,
    required this.hospital,
    required this.disease,
    required this.contact,
    required this.units,
    this.location,
    required this.date,
    required this.status,
    this.createdAt,
  });

  factory RequestModel.fromMap(String id, Map<String, dynamic> data) {
    return RequestModel(
      id: id,
      userId: data['userId'] ?? '',
      donorId: data['donorId'],
      patientName: data['patientName'] ?? '',
      bloodType: data['bloodType'] ?? '',
      hospital: data['hospital'] ?? '',
      disease: data['disease'] ?? '',
      contact: data['contact'] ?? '',
      units: data['units'] ?? 1,
      location: data['location'],
      date: data['date'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'donorId': donorId,
      'patientName': patientName,
      'bloodType': bloodType,
      'hospital': hospital,
      'disease': disease,
      'contact': contact,
      'units': units,
      'location': location,
      'date': date,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
