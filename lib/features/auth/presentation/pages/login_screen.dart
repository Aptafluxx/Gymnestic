import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/shake_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlack,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  const SizedBox(height: 20),

                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      style: textTheme.displayMedium?.copyWith(
                        letterSpacing: 6.0,
                        fontWeight: FontWeight.w700,
                      ),
                      children: const [
                        TextSpan(
                          text: 'GYMNES',
                          style: TextStyle(color: AppColors.textWhite),
                        ),
                        TextSpan(
                          text: 'TIC',
                          style: TextStyle(color: AppColors.primaryRed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Be an Inspiration',
                    style: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.grayLight,
                    ),
                  ),
                  const SizedBox(height: 48),

                  ShakeWidget(
                    key: controller.shakeKey,
                    deltaX: 10.0,
                    duration: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: .end,
                      children: [
                        Obx(
                          () => AuthTextField(
                            controller: controller.emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: controller.onEmailChanged,
                            errorText: controller.emailError,
                            textInputAction: .next,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => AuthTextField(
                            controller: controller.passwordController,
                            hintText: 'Password',
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: controller.isPasswordObscured.value,
                            onChanged: controller.onPasswordChanged,
                            errorText: controller.passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordObscured.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.grayMedium,
                                size: 20,
                              ),
                              splashRadius: 20,
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            textInputAction: .done,
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: controller.onForgotPassword,
                          child: Text(
                            'Forgot Password?',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: .w500,
                              decoration: .underline,
                              decorationColor: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    return ElevatedButton(
                      onPressed: isLoading ? null : controller.onLogin,
                      child: isLoading
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.textWhite,
                              size: 24,
                            )
                          : Text(
                              'Login',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                    );
                  }),
                  const SizedBox(height: 44),

                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Have an Account? Login',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: .w500,
                        decoration: .underline,
                        decorationColor: AppColors.textWhite,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
