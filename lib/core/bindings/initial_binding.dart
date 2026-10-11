import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/signout_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(FirebaseAuth.instance),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SignUpUseCase>(
      () => SignUpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SignOutUseCase>(
      () => SignOutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
