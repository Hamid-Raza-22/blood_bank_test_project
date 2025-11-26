import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
final String id;
final String userId;
final String title;
final String body;
final String type;
final bool read;
final DateTime? timestamp;

NotificationModel({
required this.id,
required this.userId,
required this.title,
required this.body,
required this.type,
this.read = false,
this.timestamp,
});

factory NotificationModel.fromMap(String id, Map<String, dynamic> data) {
return NotificationModel(
id: id,
userId: data['userId'] ?? '',
title: data['title'] ?? '',
body: data['body'] ?? '',
type: data['type'] ?? '',
read: data['read'] ?? false,
timestamp: data['timestamp']?.toDate(),
);
}

Map<String, dynamic> toMap() {
return {
'userId': userId,
'title': title,
'body': body,
'type': type,
'read': read,
'timestamp': timestamp,
};
}
}