import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app_user.dart';

class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Current user stream - এটি real-time auth state changes track করে
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? AppUser.fromFirebaseUser(user) : null;
    });
  }

  // Current user getter
  AppUser? get currentUser {
    final User? user = _auth.currentUser;
    return user != null ? AppUser.fromFirebaseUser(user) : null;
  }

  // Email/Password দিয়ে Sign Up
  Future<AppUser?> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Firebase Auth এ user তৈরি করি
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Display name update করি যদি provide করা হয়
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName.trim());
          await user.reload(); // User data reload করি
        }

        // Email verification পাঠাই
        await user.sendEmailVerification();

        // Firestore এ user data save করি
        final appUser = AppUser.fromFirebaseUser(user);
        await _saveUserToFirestore(appUser);

        if (kDebugMode) {
          print('✅ User signed up: ${user.email}');
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Sign up error: ${e.message}');
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected sign up error: $e');
      }
      throw Exception('Sign up failed. Please try again.');
    }
    return null;
  }

  // Email/Password দিয়ে Sign In
  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Firestore এ last sign in update করি
        final appUser = AppUser.fromFirebaseUser(user);
        await _saveUserToFirestore(appUser);

        if (kDebugMode) {
          print('✅ User signed in: ${user.email}');
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Sign in error: ${e.message}');
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected sign in error: $e');
      }
      throw Exception('Sign in failed. Please try again.');
    }
    return null;
  }

  // Google Sign In
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Google Sign In trigger করি
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled sign in
        return null;
      }

      // Google authentication credentials পাই
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase credential তৈরি করি
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase এ sign in করি
      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;

      if (user != null) {
        // Firestore এ user data save করি
        final appUser = AppUser.fromFirebaseUser(user);
        await _saveUserToFirestore(appUser);

        if (kDebugMode) {
          print('✅ Google sign in successful: ${user.email}');
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Google sign in error: ${e.message}');
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected Google sign in error: $e');
      }
      throw Exception('Google sign in failed. Please try again.');
    }
    return null;
  }

  // Anonymous Sign In
  Future<AppUser?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      final User? user = result.user;

      if (user != null) {
        final appUser = AppUser.fromFirebaseUser(user);
        await _saveUserToFirestore(appUser);

        if (kDebugMode) {
          print('✅ Anonymous sign in successful: ${user.uid}');
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Anonymous sign in error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
    return null;
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      if (kDebugMode) {
        print('✅ Password reset email sent to: $email');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Password reset error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Email Verification পাঠানো
  Future<void> sendEmailVerification() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        if (kDebugMode) {
          print('✅ Email verification sent to: ${user.email}');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Email verification error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Profile Update
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName.trim());
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }

        await user.reload(); // User data reload করি

        // Firestore এ update করি
        final updatedUser = AppUser.fromFirebaseUser(user);
        await _saveUserToFirestore(updatedUser);

        if (kDebugMode) {
          print('✅ Profile updated successfully');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Profile update error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Password Change
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPassword);

        if (kDebugMode) {
          print('✅ Password changed successfully');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Password change error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Account Delete
  Future<void> deleteAccount(String password) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Re-authenticate if email/password user
        if (user.email != null) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
        }

        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user account
        await user.delete();

        if (kDebugMode) {
          print('✅ Account deleted successfully');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Account deletion error: ${e.message}');
      }
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      // Google sign out যদি Google user হয়
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Firebase sign out
      await _auth.signOut();

      if (kDebugMode) {
        print('✅ User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sign out error: $e');
      }
      throw Exception('Sign out failed. Please try again.');
    }
  }

  // Firestore এ user data save করা
  Future<void> _saveUserToFirestore(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
        user.toFirestore(),
        SetOptions(merge: true), // Existing data merge করি
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving user to Firestore: $e');
      }
    }
  }

  // Auth exceptions handle করা
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'requires-recent-login':
        return 'Please sign in again to continue.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}