import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/features/auth/presentation/widgets/forgot_password_dialog.dart';

import '../../../../core/widgets/shake_widget.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString email = ''.obs;
  final RxString password = ''.obs;

  final RxBool isPasswordObscured = true.obs;

  final GlobalKey<ShakeWidgetState> shakeKey = GlobalKey<ShakeWidgetState>();

  final RxBool isEmailTouched = false.obs;
  final RxBool isPasswordTouched = false.obs;

  final RxBool isLoading = false.obs;

  bool get isEmailValid => GetUtils.isEmail(email.value.trim());
  bool get isPasswordValid => password.value.length >= 6;
  bool get isFormValid => isEmailValid && isPasswordValid;

  String? get emailError {
    if (!isEmailTouched.value || email.value.isEmpty) return null;
    if (!isEmailValid) return 'Please enter a valid email address';
    return null;
  }

  String? get passwordError {
    if (!isPasswordTouched.value || password.value.isEmpty) return null;
    if (!isPasswordValid) return 'Password must be at least 6 characters';
    return null;
  }

  void onEmailChanged(String value) {
    if (!isEmailTouched.value) isEmailTouched.value = true;
    email.value = value;
  }

  void onPasswordChanged(String value) {
    if (!isPasswordTouched.value) isPasswordTouched.value = true;
    password.value = value;
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void onLogin() {
    if (!isFormValid) {
      isEmailTouched.value = true;
      isPasswordTouched.value = true;
      shakeKey.currentState?.shake();
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.home);
    });
  }

  void onForgotPassword() {
    Get.dialog(const ForgotPasswordDialog(), barrierDismissible: false);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
