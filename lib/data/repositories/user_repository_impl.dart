import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';

/// User repository implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> getUserById(String userId) async {
    try {
      final user = await remoteDataSource.getUserById(userId);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getUserByEmail(String email) async {
    try {
      final user = await remoteDataSource.getUserByEmail(email);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateUser(UserEntity user) async {
    try {
      await remoteDataSource.updateUser(
        _userModelFromEntity(user),
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateUserLocation({
    required String userId,
    required GeoPoint location,
    required String city,
  }) async {
    try {
      await remoteDataSource.updateUserLocation(userId, location, city);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      await remoteDataSource.updateFcmToken(userId, token);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getAllUsers() async {
    try {
      final users = await remoteDataSource.getAllUsers();
      return Result.success(users.map((u) => u.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> watchUser(String userId) {
    return remoteDataSource.watchUser(userId).map((user) => user?.toEntity());
  }

  _userModelFromEntity(UserEntity entity) {
    return entity;
  }
}
