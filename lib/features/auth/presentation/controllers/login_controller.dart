import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/errors/auth_exceptions.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/widgets/app_snackbar.dart';
import 'package:gymnestic/features/auth/domain/usecases/login_usecase.dart';
import 'package:gymnestic/features/auth/presentation/widgets/forgot_password_dialog.dart';

import '../../../../core/widgets/shake_widget.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase = Get.find<LoginUseCase>();

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

  Future<void> onLogin() async {
    if (!isFormValid) {
      isEmailTouched.value = true;
      isPasswordTouched.value = true;
      shakeKey.currentState?.shake();
      return;
    }

    isLoading.value = true;
    try {
      await _loginUseCase(
        email: email.value.trim(),
        password: password.value,
      );
      AppSnackbar.success('Success', 'You are now signed in.');
      Get.offAllNamed(AppRoutes.home);
    } on AuthException catch (exception) {
      shakeKey.currentState?.shake();
      AppSnackbar.error('Sign in failed', exception.message);
    } catch (_) {
      shakeKey.currentState?.shake();
      AppSnackbar.error(
        'Sign in failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
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
