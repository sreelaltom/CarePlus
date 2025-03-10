import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chat',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.teal),
        ),
      ),
    );
  }
}
