import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<UserEntity> call({
    required String username,
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailAndPassword(
      username: username,
      email: email,
      password: password,
    );
  }
}
