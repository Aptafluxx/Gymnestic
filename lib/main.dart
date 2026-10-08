import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_pages.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_theme.dart';

void main() {
  runApp(const Gymnestic());
}

class Gymnestic extends StatelessWidget {
  const Gymnestic({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gymnestic",
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
