import 'package:flutter/material.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';

class HomeOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onTap;
  final double iconSize;
  const HomeOptionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primaryContainer,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            Icon(
              icon,
              color: AppColors.teal,
              size: iconSize,
            ),
            SizedBox(
              width: sWidth * 0.3,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
