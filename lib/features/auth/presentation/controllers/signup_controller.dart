import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/shake_widget.dart';

class SignupController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString username = ''.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  final RxBool isPasswordObscured = true.obs;

  final GlobalKey<ShakeWidgetState> shakeKey = GlobalKey<ShakeWidgetState>();

  final RxBool isUsernameTouched = false.obs;
  final RxBool isEmailTouched = false.obs;
  final RxBool isPasswordTouched = false.obs;

  final RxBool isLoading = false.obs;

  bool get isUsernameValid => username.value.trim().length >= 3;
  bool get isEmailValid => GetUtils.isEmail(email.value.trim());
  bool get isPasswordValid => password.value.length >= 6;
  bool get isFormValid => isEmailValid && isPasswordValid;

  String? get usernameError {
    if (!isUsernameTouched.value || username.value.isEmpty) return null;
    if (!isUsernameValid) return 'Username must be at least 3 characters';
    return null;
  }

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

  void onUsernameChanged(String value) {
    if (!isUsernameTouched.value) isUsernameTouched.value = true;
    username.value = value;
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

  void onSignup() {
    if (!isFormValid) {
      isUsernameTouched.value = true;
      isEmailTouched.value = true;
      isPasswordTouched.value = true;
      shakeKey.currentState?.shake();
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      // Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
