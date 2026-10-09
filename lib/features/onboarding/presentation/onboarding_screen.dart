import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_1.png',
              fit: .cover,
              width: .infinity,
              height: .infinity,
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.65, 0.85, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.backgroundBlack.withValues(alpha: 0.60),
                    AppColors.backgroundBlack.withValues(alpha: 0.95),
                    AppColors.backgroundBlack,
                  ],
                ),
              ),
            ),
          ),

          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return _buildPageItem(context, item, screenHeight);
            },
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Obx(() {
              final currentIndex = controller.currentPage.value;
              final isLastPage = currentIndex == controller.items.length - 1;

              return Column(
                mainAxisSize: .min,
                children: [
                  Row(
                    mainAxisAlignment: .center,
                    children: List.generate(controller.items.length, (index) {
                      final isActive = index == currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const .symmetric(horizontal: 4.0),
                        height: 3.5,
                        width: isActive ? 22.0 : 16.0,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.textWhite
                              : AppColors.grayDark,
                          borderRadius: .circular(2.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: .infinity,
                    height: 52,
                    child: isLastPage
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            onPressed: controller.nextPage,
                            child: Text(
                              'Get Started',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: .w600),
                            ),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed.withValues(
                                alpha: 0.05,
                              ),
                              side: const BorderSide(
                                color: AppColors.primaryRed,
                                style: .solid,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(30),
                              ),
                            ),
                            onPressed: controller.nextPage,
                            child: Text(
                              'Next',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: .w600,
                                    color: AppColors.primaryRed,
                                  ),
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(
    BuildContext context,
    dynamic item,
    double screenHeight,
  ) {
    return Padding(
      padding: const .only(bottom: 220),
      child: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .end,
        children: [
          Padding(
            padding: const .symmetric(horizontal: 24.0),
            child: Text(
              item.title,
              textAlign: .center,
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(height: 1.2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.subtitle,
            textAlign: .center,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
