import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  // ------------------- SIGN UP -------------------
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'createdAt': DateTime.now().toIso8601String(),
          'signInMethod': 'email_password',
          'photoURL': null, // No photoURL for email sign-up
        });
        print("AuthService LOG: User signed up: ${user.email}");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("AuthService ERROR: Sign-up failed: ${e.code}");
      throw _handleFirebaseError(e);
    }
  }

  // ------------------- SIGN IN -------------------
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential cred =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = cred.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        }).catchError((e) {
          print("Firestore update error: $e");
        });
        print("AuthService LOG: User signed in: ${user.email}");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("AuthService ERROR: Sign-in failed: ${e.code}");
      throw _handleFirebaseError(e);
    }
  }

  // ------------------- GOOGLE SIGN-IN -------------------
  Future<User?> signInWithGoogle() async {
    try {
      // Clear previous Google session
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("AuthService LOG: Google Sign-In cancelled by user.");
        throw "Google Sign-In cancelled.";
      }

      print("AuthService LOG: Google user selected: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Save or update user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? 'assets/user1.png', // Save Google photoURL
          'signInMethod': 'google',
          'createdAt': user.metadata.creationTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
          'lastLogin': DateTime.now().toIso8601String(),
        }, SetOptions(merge: true)).catchError((e) {
          print("Firestore write error: $e");
        });

        print("AuthService LOG: User authenticated: ${user.email}, photoURL: ${user.photoURL}");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("AuthService ERROR: FirebaseAuthException Code: ${e.code}");
      throw _handleFirebaseError(e);
    } catch (e) {
      print("AuthService ERROR: Generic error during sign-in: ${e.toString()}");
      throw "Google Sign-In failed: ${e.toString()}";
    }
  }

  // ------------------- UPDATE USER PROFILE -------------------
  Future<void> updateUserProfile(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("AuthService LOG: No user signed in for profile update");
      throw "No user signed in";
    }

    try {
      await user.updateDisplayName(displayName);
      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': displayName,
        'lastUpdated': DateTime.now().toIso8601String(),
        'photoURL': user.photoURL ?? 'assets/user1.png', // Preserve photoURL
      }).catchError((e) {
        print("Firestore update error: $e");
      });
      print("AuthService LOG: Profile updated: ${user.email}, displayName: $displayName");
    } catch (e) {
      print("AuthService ERROR: Profile update failed: $e");
      throw "Profile update failed: ${e.toString()}";
    }
  }

  // ------------------- PASSWORD UPDATE -------------------
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("AuthService LOG: No user signed in for password update");
      throw "No user signed in";
    }
    await user.updatePassword(newPassword);
    print("AuthService LOG: Password updated for ${user.email}");
  }

  // ------------------- SIGN OUT -------------------
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("AuthService LOG: User signed out");
  }

  // ------------------- DUMMY OTP EMAIL FUNCTION -------------------
  Future<void> sendOtpEmail(String email, String otp) async {
    print("📩 OTP sent to $email: $otp");
    // Integrate real email service if needed
  }

  // ------------------- PASSWORD RESET (by Email) -------------------
  Future<void> resetPasswordByEmail(String email, String newPassword) async {
    print("🔐 Reset password for $email -> New Password: $newPassword");
    // Implement actual password reset logic if needed
  }

  // ------------------- ERROR HANDLER -------------------
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'weak-password':
        return "Password is too weak.";
      case 'network-request-failed':
        return "Network error. Check your internet connection.";
      case 'invalid-credential':
        return "Invalid Google credentials. Check your Firebase setup (SHA/Reversed Client ID).";
      case 'account-exists-with-different-credential':
        return "Account already exists with a different sign-in method.";
      default:
        return "Authentication error: ${e.message}";
    }
  }
}