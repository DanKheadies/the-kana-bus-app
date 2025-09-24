import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:kana_bus_app/barrel.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final Logger _log;

  AuthRepository({auth.FirebaseAuth? firebaseAuth, Logger? log})
    : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
      _log = log ?? Logger();

  /// Get Firebase's current user.
  auth.User? getUser() {
    try {
      final currentUser = _firebaseAuth.currentUser;

      return currentUser;
    } catch (err) {
      _log.e('get user error', error: err);
      throw Exception(err);
    }
  }

  /// A stream for Firebase's user changes.
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  /// Authenticate with Firebase's email-password.
  Future<auth.User?> loginWithFirebase({
    required String email,
    required String password,
  }) async {
    try {
      final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );

      return userCredentials.user;
    } catch (err) {
      _log.e('login error', error: err);
      throw Exception(err);
    }
  }

  /// Create a user account on Firebase with email and password.
  Future<auth.User?> registerUserWithFirebase({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await UserRepository().createUser(
        user: User.emptyUser.copyWith(
          id: userCredentials.user!.uid,
          email: email,
          // updatedAt: userCredentials.user!.metadata.creationTime,
        ),
      );

      return userCredentials.user;
    } catch (err) {
      _log.e('register user error', error: err);
      throw Exception(err);
    }
  }

  /// Send a Firebase auth password reset.
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (err) {
      _log.e('reset password error', error: err);
      throw Exception(err);
    }
  }

  /// Delete a user account via Firebase.
  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser!.delete();
    } on auth.FirebaseAuthException catch (e) {
      _log.e('(firebase) delete user error', error: e);
    } catch (err) {
      _log.e('delete user error', error: err);
      throw Exception(err);
    }
    return;
  }

  /// Log out
  Future<void> signOut() async {
    if (_firebaseAuth.currentUser != null) {
      try {
        await _firebaseAuth.signOut();
      } catch (err) {
        _log.e('firebase sign out error', error: err);
      }
    }
  }
}
