import 'package:flutter/material.dart';

import 'package:frontend/features/auth/presentation/widgets/auth_input.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PasswordField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmit;
  final ValueNotifier<bool> visibility;
  const PasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.visibility,
    this.validator,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visibility,
      builder: (context, value, child) {
        return AuthInput(
          hintText: hintText,
          controller: controller,
          focusNode: focusNode,
          obscureText: value,
          validator: validator,
          onSubmit: onSubmit,
          suffixWidget: GestureDetector(
            onTap: () => visibility.value = !value,
            child: Icon(
              visibility.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
