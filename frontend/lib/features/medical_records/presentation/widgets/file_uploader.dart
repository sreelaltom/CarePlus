import 'package:flutter/material.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';

class FileUploader extends StatelessWidget {
  const FileUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    final sHeight = Responsive.screenHeight(context);
    return Container(
      width: sWidth,
      height: sHeight * 0.25,
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        border: Border.all(color: AppColors.teal),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.teal,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            "Choose a file",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.white),
          ),
          Text(
            "JPEG and PDF formats, up to 10MB",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style:
                Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      minimumSize:
                          WidgetStatePropertyAll(Size(sWidth / 3, 30)),
                      foregroundColor:
                          WidgetStatePropertyAll(AppColors.teal),
                    ),
            child: Text("Browse File"),
          )
        ],
      ),
    );
  }
}