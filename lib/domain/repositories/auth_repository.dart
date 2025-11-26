import '../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Auth repository interface - defines the contract for authentication
abstract class AuthRepository {
  /// Get current authenticated user
  UserEntity? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of auth state changes
  Stream<UserEntity?> get authStateChanges;

  /// Sign in with email and password
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Result<UserEntity>> signInWithGoogle();

  /// Sign out
  Future<Result<void>> signOut();

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Reset password with OTP
  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Update user profile
  Future<Result<void>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Save FCM token
  Future<Result<void>> saveFcmToken(String token);
}
