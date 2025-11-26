import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
final String id;
final String senderId;
final String text;
final DateTime? timestamp;

MessageModel({
required this.id,
required this.senderId,
required this.text,
this.timestamp,
});

factory MessageModel.fromMap(String id, Map<String, dynamic> data) {
return MessageModel(
id: id,
senderId: data['senderId'] ?? '',
text: data['text'] ?? '',
timestamp: data['timestamp']?.toDate(),
);
}

Map<String, dynamic> toMap() {
return {
'senderId': senderId,
'text': text,
'timestamp': timestamp,
};
}
}