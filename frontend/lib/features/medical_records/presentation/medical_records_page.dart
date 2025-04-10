import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart' show MedicalRecordCategory;
import 'package:frontend/core/common/app_utilities.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medical_records/presentation/bloc/file_operations_cubit/file_operations_cubit.dart';
import 'package:frontend/features/medical_records/presentation/bloc/medical_records_bloc/medical_records_bloc.dart';

import 'package:frontend/features/medical_records/presentation/widgets/app_dropdown.dart';
import 'package:frontend/features/medical_records/presentation/widgets/dialog_button.dart';
import 'package:frontend/features/medical_records/presentation/widgets/file_name_field.dart';
import 'package:frontend/features/medical_records/presentation/widgets/medical_records_list.dart';
import 'package:frontend/features/medical_records/presentation/widgets/upload_option.dart';
import 'package:go_router/go_router.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  late final ValueNotifier<MedicalRecordCategory> _categorySelectionNotifier;
  late final TextEditingController _fileNameController;

  @override
  void initState() {
    _categorySelectionNotifier =
        ValueNotifier<MedicalRecordCategory>(MedicalRecordCategory.labResult);
    _fileNameController = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final sHeight = MediaQuery.of(context).size.height;
    return BlocListener<FileOperationsCubit, FileOperationState>(
      listenWhen: (previous, current) =>
          previous != current &&
          [
            UploadSuccess,
            UploadFailure,
            UploadConfirmation,
            DeleteSuccess,
            DeleteRequested,
            DeleteFailure
          ].contains(current.runtimeType),
      listener: (context, state) {
        switch (state) {
          case UploadConfirmation _:
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: AppColors.darkNavy,
                  title: Text(
                    "Upload File",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.white),
                  ),
                  content: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: sHeight * 0.35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 16,
                      children: [
                        FileNameField(
                          fileName: state.fileName,
                          controller: _fileNameController
                            ..text = state.fileName,
                        ),
                        AppDropdown(
                          selectionNotifier: _categorySelectionNotifier,
                          items: MedicalRecordCategory.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.dropdownValue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    UploadDialogButton(
                      onPressed: () {
                        context.read<FileOperationsCubit>().reset();
                        dialogContext.pop();
                      },
                      isActionProceed: false,
                      label: "Cancel",
                    ),
                    UploadDialogButton(
                      onPressed: () {
                        context.read<FileOperationsCubit>().uploadFile(
                              filePath: state.filePath,
                              fileName: _fileNameController.text.isNotEmpty
                                  ? _fileNameController.text.trim()
                                  : state.fileName,
                              type: _categorySelectionNotifier.value,
                            );
                        dialogContext.pop();
                      },
                      label: "Upload",
                    ),
                  ],
                );
              },
            );
            break;
          case UploadSuccess _:
            context
                .read<MedicalRecordsBloc>()
                .add(AddMedicalRecordEvent(newRecord: state.medicalRecord));
          case UploadFailure _:
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state is UploadSuccess
                      ? "File uploaded successfully"
                      : "Upload failed!"),
                ),
              );
            break;
          case DeleteRequested _:
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: AppColors.darkNavy,
                  title: Text(
                    "Delete File",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.white),
                  ),
                  content: Text(
                    "Are you sure you want to delete ${state.record.id}?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.white),
                  ),
                  actions: [
                    UploadDialogButton(
                      onPressed: () {
                        context.read<FileOperationsCubit>().reset();
                        dialogContext.pop();
                      },
                      label: "Cancel",
                      isActionProceed: false,
                    ),
                    UploadDialogButton(
                      onPressed: () {
                        context
                            .read<FileOperationsCubit>()
                            .deleteFile(record: state.record);
                        dialogContext.pop();
                      },
                      label: "Yes",
                    ),
                  ],
                );
              },
            );
          case DeleteSuccess _:
            context.read<MedicalRecordsBloc>().add(
                  RemoveMedicalRecordEvent(fileId: state.fileId),
                );
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text("${state.fileName} deleted successfully"),
                ),
              );
            break;
          case DeleteFailure _:
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            break;
          default:
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: const Text("Unhandled state in listener"),
                ),
              );
        }
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
            buildWhen: (previous, current) =>
                (previous != current) ||
                (previous is MedicalRecordsLoaded &&
                    current is MedicalRecordsLoaded &&
                    previous.medicalRecords != current.medicalRecords),
            builder: (context, state) {
              switch (state) {
                case MedicalRecordsInitial _:
                case MedicalRecordsLoading _:
                  return const Center(child: CircularProgressIndicator());
                case MedicalRecordsLoaded _:
                  return MedicalRecordsList(
                    medicalRecords: state.medicalRecords,
                  );
                case MedicalRecordsFailed _:
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            state.error ??
                                "An error occurred while fetching file",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context
                              .read<MedicalRecordsBloc>()
                              .add(GetAllMedicalRecordsEvent()),
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                shape: const WidgetStatePropertyAll(
                                  StadiumBorder(),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.all(4),
                                ),
                                minimumSize:
                                    const WidgetStatePropertyAll(Size(100, 40)),
                              ),
                          child: Text(
                            "Try Again",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.primary),
                          ),
                        )
                      ],
                    ),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          onPressed: () {
            AppUtilities.showUploadOptions(
              context,
              height: 130,
              options: [
                UploadOption(
                  onSelected: () {
                    context.read<FileOperationsCubit>().captureImage();
                    context.pop();
                  },
                  label: "Camera",
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.white,
                  ),
                ),
                UploadOption(
                  onSelected: () {
                    context.read<FileOperationsCubit>().selectFile();
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

  @override
  void dispose() {
    _categorySelectionNotifier.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}
