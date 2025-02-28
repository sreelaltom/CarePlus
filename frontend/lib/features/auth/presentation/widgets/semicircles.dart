import 'package:flutter/material.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'dart:ui' as ui;

class Semicircles extends StatelessWidget {
  // final double rectWidth;
  // final double rectHeight;
  final double? top;
  final double? bottom;
  final double? right;
  final double? left;
  final bool isLeft;

  const Semicircles({
    super.key,
    required this.isLeft,
    // required this.rectHeight,
    // required this.rectWidth,
    this.top,
    this.bottom,
    this.right,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    final sHeight = Responsive.screenHeight(context);

    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: CustomPaint(
        size: Size(sWidth * 0.6, sHeight * 0.6),
        painter: SemicirclePainter(context, isLeft: isLeft),
      ),
    );
  }
}

class SemicirclePainter extends CustomPainter {
  final bool isLeft;
  final BuildContext context;

  SemicirclePainter(
    this.context, {
    super.repaint,
    required this.isLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ifMobile = Responsive.isMobile(context);
    final center1 =
        Offset(w * (isLeft ? 0.85 : 0.15), h * (isLeft ? 0.3 : 0.7));
    final center2 =
        Offset(w * (isLeft ? 0.9 : 0.1), h * (isLeft ? 0.35 : 0.65));
    final center3 =
        Offset(w * (isLeft ? 0.95 : 0.05), h * (isLeft ? 0.55 : 0.45));
    final paint1 = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;
    final paint2 = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(isLeft ? w : 0, isLeft ? 0 : h),
        Offset(isLeft ? w : 0, h * 0.5),
        [AppColors.teal, AppColors.black],
      );
    final paint6 = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(isLeft ? w : 0, isLeft ? 0 : h),
        Offset(isLeft ? 0 : w, isLeft ? h : 0),
        [AppColors.pineGreen, AppColors.teal, AppColors.teal1],
        [0, 0.5, 1],
      );
    final paint5 = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.radial(
        center2,
        h * 0.4,
        [AppColors.teal, AppColors.teal1],
      );
    final paint3 = Paint()
      ..color = AppColors.teal1
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(isLeft ? w : 0, isLeft ? h : 0)
      ..arcToPoint(
        Offset(isLeft ? w : 0, isLeft ? 0 : h),
        radius: Radius.elliptical(17, 22),
        clockwise: true,
      );

    final path2 = Path()
      ..moveTo(isLeft ? w : 0, h * (isLeft ? 0.45 : 0.55))
      ..arcToPoint(
        Offset(isLeft ? w : 0, isLeft ? 0 : h),
        radius: Radius.elliptical(17, 20),
        clockwise: true,
      );
    final path3 = Path()
      ..moveTo(isLeft ? w : 0, h * (isLeft ? 0.4 : 0.6))
      ..arcToPoint(
        Offset(isLeft ? w : 0, isLeft ? h : 0),
        radius: Radius.elliptical(17, 20),
        clockwise: false,
      );
    if (ifMobile) {
      canvas.drawPath(path1, paint1);
      canvas.drawPath(path2, paint2);
      canvas.drawPath(path3, paint3);
    } else {
      final boundingRect = Rect.fromLTWH(0, 0, w, h);
      canvas.clipRect(boundingRect);
      canvas.drawCircle(center1, h * 0.7, paint1);
      canvas.drawCircle(center2, h * 0.4, paint5);
      canvas.drawCircle(center3, h * 0.45, paint6);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
