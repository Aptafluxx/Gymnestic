import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  UserEntity? getCurrentUser();
}
