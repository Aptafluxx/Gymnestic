import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.backgroundBlack,

      textTheme: AppTextTheme.darkTextTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundBlack,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textWhite),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.textWhite,
          textStyle: AppTextTheme.darkTextTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          minimumSize: const Size(double.infinity, 55),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        surface: AppColors.surfaceDark,
        onPrimary: AppColors.textWhite,
        onSurface: AppColors.textOffWhite,
      ),
    );
  }
}
