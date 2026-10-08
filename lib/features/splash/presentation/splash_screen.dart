import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/features/splash/controller/splash_controller.dart';
import 'package:gymnestic/features/splash/presentation/widgets/dashed_curve_painter.dart';
import 'package:gymnestic/features/splash/presentation/widgets/vertical_bands_background.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Stack(
        children: [
          const VerticalBandsBackground(),

          Positioned.fill(child: CustomPaint(painter: DashedCurvePainter())),

          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 150,
                    width: 150,
                    filterQuality: .high,
                  ),

                  const Spacer(flex: 3),

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(letterSpacing: 8.0),
                      children: const [
                        TextSpan(
                          text: 'GYMNES',
                          style: TextStyle(color: AppColors.textWhite),
                        ),
                        TextSpan(
                          text: 'TIC',
                          style: TextStyle(color: AppColors.primaryRed),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
