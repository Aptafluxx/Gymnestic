import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signUpWithEmailAndPassword(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  UserEntity? getCurrentUser() => _remoteDataSource.getCurrentUser();
}
