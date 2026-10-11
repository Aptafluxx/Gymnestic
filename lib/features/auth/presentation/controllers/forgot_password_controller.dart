import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
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
      // final auth = FirebaseAuth.instance;
      // await auth.sendPasswordResetEmail(email: email.value.trim());

      isEmailSent.value = true;
    } catch (e) {
      // Map Firebase error codes to friendly explanations
      // switch (e.code) {
      //   case 'user-not-found':
      //     errorMessage.value =
      //         'No account found with this email. Please check your spelling.';
      //     break;
      //   case 'invalid-email':
      //     errorMessage.value = 'The email address format is invalid.';
      //     break;
      //   case 'network-request-failed':
      //     errorMessage.value =
      //         'Network error. Please check your internet connection.';
      //     break;
      //   case 'too-many-requests':
      //     errorMessage.value = 'Too many attempts. Please wait a few minutes before trying again.';
      //     break;
      //   case 'user-disabled':
      //     errorMessage.value =
      //         'This account has been disabled. Please contact support.';
      //     break;
      //   default:
      //     errorMessage.value = e.message ?? 'An unexpected error occurred.';
      // }
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
