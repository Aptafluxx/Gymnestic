import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/auth_exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  UserModel? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Unable to sign in. Please try again.');
      }
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthException(exception);
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('Unable to create your account. Please try again.');
      }

      await user.updateDisplayName(username);
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw const AuthException('Unable to load your new account. Please sign in.');
      }
      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthException(exception);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthException(exception);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthException(exception);
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : UserModel.fromFirebaseUser(user);
  }

  AuthException _mapFirebaseAuthException(FirebaseAuthException exception) {
    final message = switch (exception.code) {
      'user-not-found' => 'No account found with this email address.',
      'wrong-password' || 'invalid-credential' =>
        'The email or password you entered is incorrect.',
      'email-already-in-use' => 'An account already exists with this email.',
      'weak-password' => 'Please choose a stronger password.',
      'invalid-email' => 'Please enter a valid email address.',
      'network-request-failed' =>
        'Network error. Please check your internet connection.',
      'too-many-requests' =>
        'Too many attempts. Please wait a few minutes before trying again.',
      _ => exception.message ?? 'Authentication failed. Please try again.',
    };
    return AuthException(message);
  }
}
