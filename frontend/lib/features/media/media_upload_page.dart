import 'package:flutter/material.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';

class MediaUploadPage extends StatelessWidget {
  const MediaUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    final sHeight = Responsive.screenHeight(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: sWidth,
              height: sHeight * 0.25,
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
                border: Border.all(color: AppColors.teal),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
