import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart'
    show AnalysisType, CtScanCategory;
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/home/presentation/bloc/analysis_result/analysis_result_cubit.dart';
import 'package:frontend/features/home/presentation/bloc/analysis_result/analysis_result_state.dart';
import 'package:frontend/features/medical_records/presentation/widgets/app_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AnalysisResultsPage extends StatefulWidget {
  final AnalysisType analysisType;
  final BuildContext otherContext;
  final XFile file;
  const AnalysisResultsPage(
    this.otherContext, {
    super.key,
    required this.analysisType,
    required this.file,
  });

  @override
  State<AnalysisResultsPage> createState() => _AnalysisResultsPageState();
}

class _AnalysisResultsPageState extends State<AnalysisResultsPage> {
  late final ValueNotifier<CtScanCategory> _categorySelectionNotifier;

  @override
  void initState() {
    _categorySelectionNotifier = ValueNotifier(CtScanCategory.chest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    return BlocListener<AnalysisResultCubit, AnalysisResultState>(
      listenWhen: (previous, current) =>
          previous != current && current is AnalysisResultLoaded,
      listener: (context, state) {
        switch (state) {
          case AnalysisResultLoaded _:
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Analysis Results"),
          leading: IconButton(
            onPressed: () {
              context.pop();
              context.read<AnalysisResultCubit>().reset();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              if (widget.analysisType == AnalysisType.ctScanAnalysis)
                AppDropdown(
                  selectionNotifier: _categorySelectionNotifier,
                  items: CtScanCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                )
              else
                SizedBox(width: sWidth),
              Container(
                width: sWidth * 0.8,
                height: sWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: FileImage(File(widget.file.path)),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        widget.analysisType == AnalysisType.ctScanAnalysis
                            ? context.read<AnalysisResultCubit>().analyzeImage(
                                  category: _categorySelectionNotifier.value,
                                  filePath: widget.file.path,
                                )
                            : context
                                .read<AnalysisResultCubit>()
                                .classifyFood(filePath: widget.file.path),
                    style:
                        Theme.of(context).outlinedButtonTheme.style!.copyWith(
                              minimumSize: WidgetStatePropertyAll(
                                Size(sWidth * 0.4, 45),
                              ),
                              foregroundColor: WidgetStatePropertyAll<Color>(
                                AppColors.teal,
                              ),
                              side: WidgetStatePropertyAll<BorderSide>(
                                const BorderSide(color: AppColors.teal),
                              ),
                            ),
                    child: Text(
                      widget.analysisType == AnalysisType.ctScanAnalysis
                          ? "Analyze"
                          : "Calculate",
                    ),
                  ),
                  BlocBuilder<AnalysisResultCubit, AnalysisResultState>(
                    builder: (context, state) {
                      switch (state) {
                        case AnalysisResultLoading _:
                          return Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.teal),
                          );
                        case AnalysisResultLoaded _:
                          return state.analysis != null
                              ? Text(
                                  state.analysis!.prediction,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: AppColors.teal),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: sWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: AppColors.teal)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        state.foodComposition!.foodName,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: AppColors.teal),
                                      ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Calories: ${state.foodComposition!.nutrition.calories} kCal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: AppColors.teal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Carbohydrates: ${state.foodComposition!.nutrition.carbohydrates} g/100g",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: AppColors.teal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Protein: ${state.foodComposition!.nutrition.proteins} g/100g",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: AppColors.teal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Fats: ${state.foodComposition!.nutrition.fats} g/100g",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: AppColors.teal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              "Vitamins: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: AppColors.teal),
                                            ),
                                            ...state.foodComposition!.nutrition
                                                .vitamins
                                                .map(
                                              (vitamin) => Text(
                                                "${vitamin.split(" ")[1]}, ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: AppColors.teal),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        case AnalysisResultError _:
                          return Text(
                            state.error,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.error),
                          );
                        default:
                          return SizedBox();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _categorySelectionNotifier.dispose();
    super.dispose();
  }
}
