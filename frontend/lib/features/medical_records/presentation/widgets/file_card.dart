import 'package:flutter/material.dart';
import 'package:frontend/core/assets/app_icons.dart';
import 'package:frontend/core/theme/app_colors.dart';

class FileCard extends StatelessWidget {
  final Color color;
  const FileCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        border: Border.all(color: AppColors.teal),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AppIcons.pdf, width: 40, height: 40),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  "Cancer_report.pdf",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.white),
                ),
                Text(
                  "60 KB",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppColors.darkGrey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
