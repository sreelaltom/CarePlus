import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart' show AnalysisType;
import 'package:frontend/core/common/app_utilities.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/home/presentation/bloc/analysis_result/analysis_result_cubit.dart';
import 'package:frontend/features/home/presentation/widgets/home_option_card.dart';
import 'package:frontend/features/home/presentation/bloc/image_operation/image_operation_cubit.dart';
import 'package:frontend/features/home/presentation/bloc/image_operation/image_operation_state.dart';
import 'package:frontend/features/medical_records/presentation/widgets/upload_option.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart' show ImageSource;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showImageUploadOptions(
    BuildContext context, {
    required AnalysisType analysisRequested,
  }) {
    AppUtilities.showUploadOptions(
      context,
      height: 130,
      options: [
        UploadOption(
          onSelected: () {
            context.read<AnalysisResultCubit>().reset();
            context.read<ImageOperationCubit>().selectImage(
                  source: ImageSource.camera,
                  analysisRequested: analysisRequested,
                );
            // context.pop();
          },
          label: "Camera",
          icon: const Icon(
            Icons.camera_alt_outlined,
            color: AppColors.white,
          ),
        ),
        UploadOption(
          onSelected: () {
            context.read<AnalysisResultCubit>().reset();
            context.read<ImageOperationCubit>().selectImage(
                  source: ImageSource.gallery,
                  analysisRequested: analysisRequested,
                );
            // context.pop();
          },
          label: "Gallery",
          icon: const Icon(
            Icons.photo_outlined,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageOperationCubit, ImageOperationState>(
      listenWhen: (previous, current) =>
          previous != current && current is ImageSelected,
      listener: (context, state) {
        switch (state) {
          case ImageSelected _:
            // context.read<AnalysisResultCubit>().reset();
            context.pushNamed(
              RouteNames.analysisResult,
              extra: {
                "context": context,
                "file": state.file,
                "analysis_type": state.analysisRequested,
              },
            );
            context.read<ImageOperationCubit>().reset();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            children: [
              HomeOptionCard(
                label: "CT-Scan Analyser",
                icon: Icons.document_scanner_outlined,
                onTap: () => _showImageUploadOptions(
                  context,
                  analysisRequested: AnalysisType.ctScanAnalysis,
                ),
              ),
              HomeOptionCard(
                label: "Calorie Detector",
                icon: Icons.food_bank_outlined,
                iconSize: 60,
                onTap: () => _showImageUploadOptions(
                  context,
                  analysisRequested: AnalysisType.calorieCalculation,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
