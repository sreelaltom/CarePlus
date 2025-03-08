import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.teal),
        ),
      ),
    );
  }
}
