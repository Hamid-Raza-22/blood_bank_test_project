import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
final String uid;
final String name;
final String email;
final String? bloodType;
final GeoPoint? location;
final String? photoUrl;
final bool availability;
final DateTime? lastDonationDate;
final String? fcmToken;
final DateTime? createdAt;

UserModel({
required this.uid,
required this.name,
required this.email,
this.bloodType,
this.location,
this.photoUrl,
this.availability = true,
this.lastDonationDate,
this.fcmToken,
this.createdAt,
});

factory UserModel.fromMap(Map<String, dynamic> data) {
return UserModel(
uid: data['uid'] ?? '',
name: data['name'] ?? '',
email: data['email'] ?? '',
bloodType: data['bloodType'],
location: data['location'],
photoUrl: data['photoUrl'],
availability: data['availability'] ?? true,
lastDonationDate: data['lastDonationDate']?.toDate(),
fcmToken: data['fcmToken'],
createdAt: data['createdAt']?.toDate(),
);
}

Map<String, dynamic> toMap() {
return {
'uid': uid,
'name': name,
'email': email,
'bloodType': bloodType,
'location': location,
'photoUrl': photoUrl,
'availability': availability,
'lastDonationDate': lastDonationDate,
'fcmToken': fcmToken,
'createdAt': createdAt,
};
}
}