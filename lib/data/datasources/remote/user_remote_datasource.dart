import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

/// User remote data source interface
abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<UserModel> getUserByEmail(String email);
  Future<void> updateUser(UserModel user);
  Future<void> updateUserLocation(String userId, GeoPoint location, String city);
  Future<void> updateFcmToken(String userId, String token);
  Future<List<UserModel>> getAllUsers();
  Stream<UserModel?> watchUser(String userId);
}

/// User remote data source implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _usersCollection => firestore.collection('users');

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw const NotFoundException(message: 'User not found');
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserByEmail(String email) async {
    try {
      final query = await _usersCollection.where('email', isEqualTo: email).limit(1).get();
      if (query.docs.isEmpty) {
        throw const NotFoundException(message: 'User not found');
      }
      return UserModel.fromFirestore(query.docs.first);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserLocation(String userId, GeoPoint location, String city) async {
    try {
      await _usersCollection.doc(userId).update({
        'location': location,
        'city': city,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String token) async {
    try {
      await _usersCollection.doc(userId).set({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final query = await _usersCollection.get();
      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<UserModel?> watchUser(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }
}
