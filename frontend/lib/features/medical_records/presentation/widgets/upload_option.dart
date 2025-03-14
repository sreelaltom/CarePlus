import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class UploadOption extends StatelessWidget {
  final VoidCallback onSelected;
  final Widget icon;
  final String label;

  const UploadOption({
    super.key,
    required this.onSelected,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        IconButton(
          onPressed: onSelected,
          style: IconButton.styleFrom(shape: CircleBorder()),
          icon: icon,
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
