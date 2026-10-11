import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void success(String title, String message) {
    _show(title, message, isError: false);
  }

  static void error(String title, String message) {
    _show(title, message, isError: true);
  }

  static void _show(String title, String message, {required bool isError}) {
    final accentColor = isError
        ? AppColors.primaryRed
        : const Color(0xFF3DBE8B);

    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        messageText: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.textOffWhite,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        borderRadius: 16,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutCubic,
        reverseAnimationCurve: Curves.easeInCubic,
        animationDuration: const Duration(milliseconds: 300),
        snackStyle: SnackStyle.FLOATING,
        shouldIconPulse: false,
        icon: Icon(
          isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
          color: accentColor,
          size: 24,
        ),
        leftBarIndicatorColor: accentColor,
        borderColor: AppColors.grayDark,
        borderWidth: 1,
        boxShadows: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
    );
  }
}
