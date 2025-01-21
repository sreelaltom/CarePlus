import 'package:flutter/material.dart';


class AuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const AuthButton({
    super.key,
    this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
