import 'package:flutter/material.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';

class FileNameField extends StatelessWidget {
  final String fileName;
  final TextEditingController controller;
  const FileNameField({super.key, required this.fileName, required this.controller});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    return TextField(
      controller: controller,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: AppColors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        labelText: "File Name",
        hintText: "File Name",
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.teal),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.white),
        constraints: BoxConstraints(minWidth: sWidth * 0.9),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.teal),
          borderRadius: BorderRadius.circular(5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
