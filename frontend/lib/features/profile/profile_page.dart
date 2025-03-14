import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.teal),
        ),
      ),
    );
  }
}
