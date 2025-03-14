import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/common/app_extensions.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:frontend/features/medical_records/presentation/widgets/file_card.dart';
import 'package:frontend/features/medical_records/presentation/widgets/file_uploader.dart';
import 'package:frontend/features/medical_records/presentation/widgets/upload_option.dart';
import 'dart:developer' as developer;

import 'package:go_router/go_router.dart';

class MedicalRecordsPage extends StatelessWidget {
  late final _fileNameController = TextEditingController();

  MedicalRecordsPage({super.key});

  void _showUploadOptions(
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
        developer.log(
            "CONTEXT inside showUploadOptions->builder: ${context.hashCode}");
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

  @override
  Widget build(BuildContext context) {
    developer
        .log("CONTEXT inside build(MedicalRecordsPage) : ${context.hashCode}");
    return BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is UploadMedicalRecordFailed ||
            state is UploadMedicalRecordSuccess) {
          final message = state is UploadMedicalRecordSuccess
              ? "File uploaded successfully"
              : "Upload Failed!";
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          context.read<MedicalRecordsBloc>().add(
                GetAllMedicalRecordsEvent(
                  previousMedicalRecords: state is UploadMedicalRecordFailed
                      ? state.previouslyLoadedRecords
                      : null,
                ),
              );
        } else if (state is UploadMedicalRecordConfirmation) {
          _fileNameController.text = state.fileName;
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog.adaptive(
                title: Text(
                  "Upload File",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: AppColors.white),
                ),
                content: Column(
                  children: [
                    TextField(controller: _fileNameController),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => dialogContext.pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MedicalRecordsBloc>().add(
                            UploadMedicalRecordEvent(
                              fileName: _fileNameController.text,
                              filePath: state.filePath,
                              type: MedicalRecordType.labResult,
                            ),
                          );
                      dialogContext.pop();
                    },
                    child: const Text("Upload"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showUploadOptions(
              context,
              height: 130,
              options: [
                UploadOption(
                  onSelected: () {},
                  label: "Camera",
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.white,
                  ),
                ),
                UploadOption(
                  onSelected: () {
                    context.read<MedicalRecordsBloc>().add(
                          SelectMedicalRecordEvent(
                              loadedMedicalRecords: context
                                      .read<MedicalRecordsBloc>()
                                      .state is MedicalRecordsLoaded
                                  ? (context.read<MedicalRecordsBloc>().state
                                          as MedicalRecordsLoaded)
                                      .medicalRecords
                                  : null),
                        );
                    context.pop();
                  },
                  label: "Upload",
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    color: AppColors.white,
                  ),
                ),
              ],
            );
          },
          label: const Text("New"),
        ),
      ),
    );
  }
}

// final List<Color> _colors = [
//   Color(0xFF39FF14),
//   Color(0xFFC7EA46),
//   Color(0xFF007FFF),
//   Color(0xFFFF0693),
//   Color(0xFFFFEA00),
//   Color(0xFFFF6700),
// ];
