import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/services/preferences_service.dart';
import 'package:gymnestic/features/onboarding/data/models/onboarding_item.dart';

class OnboardingController extends GetxController {
  final PreferencesService _prefs = Get.find<PreferencesService>();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      title: 'Get Stronger for\nPreparation',
      subtitle: 'Be an Inspiration',
    ),
    OnboardingItem(
      title: 'Build Your Mind\nand Body',
      subtitle: 'Be an Inspiration',
    ),
    OnboardingItem(
      title: 'Running to Your\nDream',
      subtitle: 'Be an Inspiration',
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> nextPage() async {
    if (currentPage.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await _prefs.setHasSeenOnboarding(true);

      Get.offAllNamed(AppRoutes.login);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
