import 'package:flutter/material.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/theme/app_colors.dart';

class CategoryDropdown extends StatelessWidget {
  final ValueNotifier<MedicalRecordType> categoryNotifier;
  const CategoryDropdown({super.key, required this.categoryNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: categoryNotifier,
      builder: (_, category, __) {
        return DropdownButtonFormField(
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.white),
          dropdownColor: AppColors.primary,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: AppColors.teal),
            ),
            constraints: BoxConstraints(maxHeight: 50),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.white),
          ),
          // isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          value: category,
          onChanged: (value) =>
              categoryNotifier.value = value ?? MedicalRecordType.labResult,
          items: MedicalRecordType.values
              .map(
                (type) => DropdownMenuItem<MedicalRecordType>(
                  value: type,
                  child: Text(
                    type.dropdownValue,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.white),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
