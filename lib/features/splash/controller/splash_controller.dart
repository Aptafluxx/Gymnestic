import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/services/preferences_service.dart';

class SplashController extends GetxController {
  final PreferencesService _prefs = Get.find<PreferencesService>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final hasSeenOnboarding = _prefs.hasSeenOnboarding;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (!hasSeenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (currentUser != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
