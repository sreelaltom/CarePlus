import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AppDrawerItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final void Function() onTap;

  const AppDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.darkNavy,
      onTap: onTap,
      leading: icon,
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.teal),
      ),
    );
  }
}
