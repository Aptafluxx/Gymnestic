import 'package:get/get.dart';
import 'package:gymnestic/features/auth/presentation/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
