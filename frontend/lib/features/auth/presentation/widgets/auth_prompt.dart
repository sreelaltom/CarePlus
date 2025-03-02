import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AuthPrompt extends StatelessWidget {
  final bool isComplete;
  final String text;
  final String hyperText;
  final void Function() onTap;

  
  const AuthPrompt.complete({
    super.key,
    required this.hyperText,
    required this.onTap,
  })  : text = '',
        isComplete = true;

  const AuthPrompt.partial({
    super.key,
    required this.text,
    required this.hyperText,
    required this.onTap,
  }) : isComplete = false;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: isComplete
          ? TextSpan(
              text: hyperText,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            )
          : TextSpan(
              text: text,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: hyperText,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTap,
                ),
              ],
            ),
    );
  }
}
