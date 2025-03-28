import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/presentation/bloc/file_operations_cubit/file_operations_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer show log;

class MedicalRecordsList extends StatelessWidget {
  final List<MedicalRecord> medicalRecords;

  const MedicalRecordsList({super.key, required this.medicalRecords});

  @override
  Widget build(BuildContext context) {
    return medicalRecords.isNotEmpty
        ? ListView.separated(
            itemCount: medicalRecords.length,
            itemBuilder: (context, index) {
              return Card(
                key: ValueKey(medicalRecords[index].id),
                child: SizedBox(
                  height: 70,
                  child: ListTile(
                    onTap: () async {
                      final url = Uri.parse(medicalRecords[index].url);
                      final launchable = await canLaunchUrl(url);
                      if (launchable) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        developer.log(launchable.toString());
                        developer
                            .log('LAUNCH_FAILED: ${medicalRecords[index].url}');
                      }
                    },
                    title: Text(medicalRecords[index].id.toString()),
                    subtitle: Text(
                      medicalRecords[index]
                          .createdAt
                          .toIso8601String()
                          .split('T')[0]
                          .split('-')
                          .reversed
                          .join('-'),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => context
                          .read<FileOperationsCubit>()
                          .requestDeleteFile(record: medicalRecords[index]),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
          )
        : Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Oops! You don't have any medical records yet.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
