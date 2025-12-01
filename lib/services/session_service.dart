import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// SessionService - Manages persistent login using secure storage
/// 
/// This service handles:
/// - Storing user session tokens securely
/// - Checking if user is logged in on app launch
/// - Clearing session on logout
class SessionService {
  static const String _keyUserToken = 'user_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLoginTimestamp = 'login_timestamp';
  static const String _keyAuthProvider = 'auth_provider';

  final FlutterSecureStorage _secureStorage;
  final FirebaseAuth _firebaseAuth;

  SessionService({
    FlutterSecureStorage? secureStorage,
    FirebaseAuth? firebaseAuth,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        ),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Save user session after successful login
  /// 
  /// Stores user credentials securely and marks the session as active
  Future<void> saveSession({
    required String userId,
    required String email,
    String? authProvider,
  }) async {
    try {
      // Get the current user's ID token for secure storage
      final user = _firebaseAuth.currentUser;
      String? token;
      
      if (user != null) {
        token = await user.getIdToken();
      }

      await Future.wait([
        _secureStorage.write(key: _keyIsLoggedIn, value: 'true'),
        _secureStorage.write(key: _keyUserId, value: userId),
        _secureStorage.write(key: _keyUserEmail, value: email),
        _secureStorage.write(key: _keyLoginTimestamp, value: DateTime.now().toIso8601String()),
        if (token != null) _secureStorage.write(key: _keyUserToken, value: token),
        if (authProvider != null) _secureStorage.write(key: _keyAuthProvider, value: authProvider),
      ]);

      debugPrint('SessionService: Session saved for user $email');
    } catch (e) {
      debugPrint('SessionService ERROR: Failed to save session: $e');
      rethrow;
    }
  }

  /// Check if user has a valid persistent session
  /// 
  /// Returns true if:
  /// 1. Session exists in secure storage
  /// 2. Firebase user is still authenticated
  Future<bool> isSessionValid() async {
    try {
      final isLoggedIn = await _secureStorage.read(key: _keyIsLoggedIn);
      
      if (isLoggedIn != 'true') {
        debugPrint('SessionService: No stored session found');
        return false;
      }

      // Verify Firebase auth state
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        debugPrint('SessionService: Stored session exists but Firebase user is null');
        // Session exists but Firebase user is null - try to restore
        // This can happen when app is closed and reopened
        // Firebase should auto-restore the session, wait a moment
        await Future.delayed(const Duration(milliseconds: 500));
        
        final userAfterDelay = _firebaseAuth.currentUser;
        if (userAfterDelay == null) {
          // Firebase couldn't restore session, clear our stored session
          await clearSession();
          return false;
        }
      }

      debugPrint('SessionService: Valid session found for ${currentUser?.email}');
      return true;
    } catch (e) {
      debugPrint('SessionService ERROR: Failed to check session: $e');
      return false;
    }
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _keyUserId);
  }

  /// Get stored user email
  Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _keyUserEmail);
  }

  /// Get stored auth provider (email, google, facebook, apple)
  Future<String?> getAuthProvider() async {
    return await _secureStorage.read(key: _keyAuthProvider);
  }

  /// Get login timestamp
  Future<DateTime?> getLoginTimestamp() async {
    final timestamp = await _secureStorage.read(key: _keyLoginTimestamp);
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  /// Clear user session on logout
  /// 
  /// Removes all stored credentials from secure storage
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _keyIsLoggedIn),
        _secureStorage.delete(key: _keyUserId),
        _secureStorage.delete(key: _keyUserEmail),
        _secureStorage.delete(key: _keyUserToken),
        _secureStorage.delete(key: _keyLoginTimestamp),
        _secureStorage.delete(key: _keyAuthProvider),
      ]);
      debugPrint('SessionService: Session cleared');
    } catch (e) {
      debugPrint('SessionService ERROR: Failed to clear session: $e');
      rethrow;
    }
  }

  /// Refresh the stored token
  /// 
  /// Should be called periodically or before token expiry
  Future<void> refreshToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final newToken = await user.getIdToken(true);
        if (newToken != null) {
          await _secureStorage.write(key: _keyUserToken, value: newToken);
          debugPrint('SessionService: Token refreshed');
        }
      }
    } catch (e) {
      debugPrint('SessionService ERROR: Failed to refresh token: $e');
    }
  }

  /// Get stored token (for API calls if needed)
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyUserToken);
  }
}
