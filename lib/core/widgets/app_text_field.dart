import 'package:flutter/material.dart';
import 'package:gymnestic/core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool? isPassword;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    required this.keyboardType,
    this.onChanged,
    this.errorText,
    this.textInputAction = .next,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDarker,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: hasError ? AppColors.primaryRed : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ?? false,
            keyboardType: keyboardType,
            onChanged: onChanged,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.grayMedium),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 14),
                child: Icon(
                  prefixIcon,
                  color: hasError ? AppColors.primaryRed : AppColors.grayMedium,
                  size: 20,
                ),
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: suffixIcon,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 6),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.primaryRed,
                fontSize: 12,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
      ],
    );
  }
}
