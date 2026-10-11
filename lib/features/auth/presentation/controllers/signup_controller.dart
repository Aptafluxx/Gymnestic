import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/errors/auth_exceptions.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/widgets/app_snackbar.dart';
import 'package:gymnestic/core/widgets/shake_widget.dart';
import 'package:gymnestic/features/auth/domain/usecases/signup_usecase.dart';

class SignupController extends GetxController {
  final SignUpUseCase _signUpUseCase = Get.find<SignUpUseCase>();

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
  bool get isFormValid => isUsernameValid && isEmailValid && isPasswordValid;

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

  Future<void> onSignup() async {
    if (!isFormValid) {
      isUsernameTouched.value = true;
      isEmailTouched.value = true;
      isPasswordTouched.value = true;
      shakeKey.currentState?.shake();
      return;
    }

    isLoading.value = true;
    try {
      await _signUpUseCase(
        username: username.value.trim(),
        email: email.value.trim(),
        password: password.value,
      );
      AppSnackbar.success('Success', 'Your account has been created.');
      Get.offAllNamed(AppRoutes.home);
    } on AuthException catch (exception) {
      shakeKey.currentState?.shake();
      AppSnackbar.error('Sign up failed', exception.message);
    } catch (_) {
      shakeKey.currentState?.shake();
      AppSnackbar.error(
        'Sign up failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
