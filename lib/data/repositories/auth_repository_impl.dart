import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

/// Auth repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  UserEntity? get currentUser {
    final user = remoteDataSource.currentUser;
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  @override
  bool get isAuthenticated => remoteDataSource.currentUser != null;

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) {
      if (user == null) return null;
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );
    });
  }

  @override
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(email, password);
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return Result.success(null);
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    // This would require additional implementation
    return Result.failure(const AuthFailure(message: 'Not implemented'));
  }

  @override
  Future<Result<void>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    // This would require additional implementation
    return Result.failure(const AuthFailure(message: 'Not implemented'));
  }

  @override
  Future<Result<void>> saveFcmToken(String token) async {
    try {
      final userId = remoteDataSource.currentUser?.uid;
      if (userId == null) {
        return Result.failure(const AuthFailure(message: 'User not authenticated'));
      }
      await remoteDataSource.saveFcmToken(userId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AuthFailure(message: e.toString()));
    }
  }
}
