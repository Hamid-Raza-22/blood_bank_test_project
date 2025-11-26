import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/public_need_entity.dart';

/// Public Need remote data source interface
abstract class PublicNeedRemoteDataSource {
  Future<List<PublicNeedEntity>> getAllPublicNeeds();
  Future<List<PublicNeedEntity>> getPendingNeeds();
  Future<List<PublicNeedEntity>> getNeedsByBloodType(String bloodType);
  Future<List<PublicNeedEntity>> getNeedsByUser(String userId);
  Future<PublicNeedEntity> getNeedById(String needId);
  Future<PublicNeedEntity> createNeed(PublicNeedEntity need);
  Future<void> acceptNeed(String needId, String acceptorId, String chatRoomId);
  Future<void> cancelNeed(String needId);
  Future<void> completeNeed(String needId);
  Stream<List<PublicNeedEntity>> watchPublicNeeds();
  Stream<List<PublicNeedEntity>> watchPendingNeeds();
}

/// Public Need remote data source implementation
class PublicNeedRemoteDataSourceImpl implements PublicNeedRemoteDataSource {
  final FirebaseFirestore firestore;

  PublicNeedRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _publicNeedsCollection => firestore.collection('public_needs');

  @override
  Future<List<PublicNeedEntity>> getAllPublicNeeds() async {
    try {
      final query = await _publicNeedsCollection.get();
      final needs = query.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PublicNeedEntity>> getPendingNeeds() async {
    try {
      final query = await _publicNeedsCollection
          .where('status', isEqualTo: 'pending')
          .get();
      final needs = query.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PublicNeedEntity>> getNeedsByBloodType(String bloodType) async {
    try {
      final query = await _publicNeedsCollection
          .where('bloodType', isEqualTo: bloodType)
          .where('status', isEqualTo: 'pending')
          .get();
      final needs = query.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<PublicNeedEntity>> getNeedsByUser(String userId) async {
    try {
      final query = await _publicNeedsCollection
          .where('requesterId', isEqualTo: userId)
          .get();
      final needs = query.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PublicNeedEntity> getNeedById(String needId) async {
    try {
      final doc = await _publicNeedsCollection.doc(needId).get();
      if (!doc.exists) {
        throw const NotFoundException(message: 'Public need not found');
      }
      return _needFromDoc(doc);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PublicNeedEntity> createNeed(PublicNeedEntity need) async {
    try {
      final docRef = await _publicNeedsCollection.add({
        'requesterId': need.requesterId,
        'requesterName': need.requesterName,
        'requesterPhoto': need.requesterPhoto,
        'bloodType': need.bloodType,
        'status': 'pending',
        'unitsNeeded': need.unitsNeeded,
        'urgency': need.urgency,
        'hospital': need.hospital,
        'city': need.city,
        'notes': need.notes,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final doc = await docRef.get();
      return _needFromDoc(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> acceptNeed(String needId, String acceptorId, String chatRoomId) async {
    try {
      await _publicNeedsCollection.doc(needId).update({
        'status': 'accepted',
        'acceptedBy': acceptorId,
        'chatRoomId': chatRoomId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> cancelNeed(String needId) async {
    try {
      await _publicNeedsCollection.doc(needId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> completeNeed(String needId) async {
    try {
      await _publicNeedsCollection.doc(needId).update({
        'status': 'completed',
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<PublicNeedEntity>> watchPublicNeeds() {
    return _publicNeedsCollection.snapshots().map((snapshot) {
      final needs = snapshot.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    });
  }

  @override
  Stream<List<PublicNeedEntity>> watchPendingNeeds() {
    return _publicNeedsCollection
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final needs = snapshot.docs.map((doc) => _needFromDoc(doc)).toList();
      _sortByCreatedAt(needs);
      return needs;
    });
  }

  void _sortByCreatedAt(List<PublicNeedEntity> needs) {
    needs.sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }

  PublicNeedEntity _needFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PublicNeedEntity(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      requesterPhoto: data['requesterPhoto'],
      bloodType: data['bloodType'] ?? '',
      status: data['status'] ?? 'pending',
      unitsNeeded: data['unitsNeeded'] ?? 1,
      urgency: data['urgency'] ?? 'normal',
      hospital: data['hospital'],
      city: data['city'],
      notes: data['notes'],
      acceptedBy: data['acceptedBy'],
      chatRoomId: data['chatRoomId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      acceptedAt: (data['acceptedAt'] as Timestamp?)?.toDate(),
    );
  }
}
