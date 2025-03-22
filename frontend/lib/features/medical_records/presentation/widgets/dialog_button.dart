import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class UploadDialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isActionProceed;

  const UploadDialogButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.isActionProceed = true,});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isActionProceed ? AppColors.teal : AppColors.white,
        maximumSize: const Size(90, 40),
        minimumSize: const Size(90, 40),
        shape: StadiumBorder(),
      ),
      child: Text(
        label,
        // style: Theme.of(context)
        //     .textTheme
        //     .bodySmall!
        //     .copyWith(color: AppColors.white),
      ),
    );
  }
}
