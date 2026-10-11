import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/forgot_password_controller.dart';
import 'auth_text_field.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: .circular(30)),
        insetPadding: const .symmetric(horizontal: 24.0),
        child: Padding(
          padding: const .all(24.0),
          child: Obx(() {
            if (controller.isEmailSent.value) {
              return _buildSuccessView(context, controller, textTheme);
            }
            return _buildFormView(context, controller, textTheme);
          }),
        ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context,
    ForgotPasswordController controller,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          'Reset Password',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: .w700,
            color: AppColors.textWhite,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        Text(
          'Enter the email address associated with your GYMNESTIC account. We will send you a link to reset your password.',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        AuthTextField(
          controller: controller.emailController,
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: controller.onEmailChanged,
          errorText: controller.emailError,
          textInputAction: .done,
        ),

        if (controller.errorMessage.value.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const .symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.15),
              borderRadius: .circular(12),
              border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  side: const BorderSide(
                    color: AppColors.grayMedium,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        Get.delete<ForgotPasswordController>();
                        Navigator.of(context).pop();
                      },
                child: Text(
                  'Cancel',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
                ),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.sendResetEmail,
                child: controller.isLoading.value
                    ? LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primaryRed,
                        size: 20,
                      )
                    : Text(
                        'Send Link',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    ForgotPasswordController controller,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.primaryRed,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),

        Text(
          'Email Sent!',
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        Text(
          'We have sent a password reset link to:\n${controller.email.value.trim()}\n\nPlease check your inbox (and spam folder) and follow the instructions.',
          style: textTheme.bodyMedium?.copyWith(height: 1.45),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () {
            Get.delete<ForgotPasswordController>();
            Navigator.of(context).pop();
          },
          child: Text(
            'Got It',
            style: textTheme.bodyMedium?.copyWith(fontWeight: .w700),
          ),
        ),
      ],
    );
  }
}
