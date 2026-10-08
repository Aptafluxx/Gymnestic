import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  static TextTheme get darkTextTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Lora',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Lora',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),

      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textOffWhite,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),

      labelLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
    );
  }
}
