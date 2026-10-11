import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/auth_exceptions.dart';
import '../../domain/usecases/reset_password_usecase.dart';

class ForgotPasswordController extends GetxController {
  final ResetPasswordUseCase _resetPasswordUseCase =
      Get.find<ResetPasswordUseCase>();

  final emailController = TextEditingController();

  final RxString email = ''.obs;
  final RxBool isEmailTouched = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEmailSent = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isEmailValid => GetUtils.isEmail(email.value.trim());

  String? get emailError {
    if (!isEmailTouched.value || email.value.isEmpty) return null;
    if (!isEmailValid) return 'Please enter a valid email address';
    return null;
  }

  void onEmailChanged(String value) {
    if (!isEmailTouched.value) isEmailTouched.value = true;
    email.value = value;
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
  }

  Future<void> sendResetEmail() async {
    isEmailTouched.value = true;

    if (!isEmailValid) {
      errorMessage.value = 'Please enter a valid email address.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _resetPasswordUseCase(email: email.value.trim());
      isEmailSent.value = true;
    } on AuthException catch (exception) {
      errorMessage.value = exception.message;
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void resetState() {
    emailController.clear();
    email.value = '';
    isEmailTouched.value = false;
    isLoading.value = false;
    isEmailSent.value = false;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
