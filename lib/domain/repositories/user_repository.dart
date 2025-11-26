import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// User repository interface - defines the contract for user operations
abstract class UserRepository {
  /// Get user by ID
  Future<Result<UserEntity>> getUserById(String userId);

  /// Get user by email
  Future<Result<UserEntity>> getUserByEmail(String email);

  /// Update user data
  Future<Result<void>> updateUser(UserEntity user);

  /// Update user location
  Future<Result<void>> updateUserLocation({
    required String userId,
    required GeoPoint location,
    required String city,
  });

  /// Update user FCM token
  Future<Result<void>> updateFcmToken({
    required String userId,
    required String token,
  });

  /// Get all users (for notifications)
  Future<Result<List<UserEntity>>> getAllUsers();

  /// Stream user data changes
  Stream<UserEntity?> watchUser(String userId);
}
