import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopButton extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final VoidCallback? onPressed;

  const PopButton({
    super.key,
    this.onPressed,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right ?? 50,
      top: top ?? 50,
      bottom: bottom,
      left: left,
      child: IconButton(
        onPressed: onPressed ?? () => context.pop(),
        icon: Icon(Icons.arrow_back_outlined),
        style: Theme.of(context).iconButtonTheme.style!.copyWith(
              minimumSize: WidgetStatePropertyAll<Size>(Size(100, 55)),
              shape: WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
            ),
      ),
    );
  }
}
