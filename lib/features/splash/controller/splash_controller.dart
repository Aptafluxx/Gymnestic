import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    Get.offAllNamed(AppRoutes.onboarding);
  }
}
