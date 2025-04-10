import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medical_records/presentation/widgets/upload_option.dart';
import 'dart:developer' as developer show log;

abstract class AppUtilities {
  static void showUploadOptions(
    BuildContext context, {
    required List<UploadOption> options,
    double height = 150,
  }) {
    developer.log("CONTEXT inside showUploadOptions: ${context.hashCode}");
    final sWidth = MediaQuery.of(context).size.width;
    final rows = (options.length / 3).ceil();

    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: sWidth / (options.length < 3 ? 2 : 3 / rows),
      ),
      useRootNavigator: true,
      backgroundColor: AppColors.primary,
      context: context,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    MediaQuery.of(bottomSheetContext).size.width /
                        (options.length < 3 ? 2 : 3),
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              children: options,
            ),
          ),
        );
      },
    );
  }
}
