import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/features/home/controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [SizedBox(height: 50, width: 50, child: Text("Tap"))],
        ),
      ),
    );
  }
}
