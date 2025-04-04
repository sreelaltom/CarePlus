import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class DateSelector extends StatelessWidget {
  // final ValueNotifier<String> dateSelectionNotifier;
  final bool enabled;
  final String label;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final void Function()? onTap;
  // final void Function(String)? onChanged;
  const DateSelector({
    super.key,
    this.initialDate,
    this.firstDate,
    this.enabled = true,
    // required this.dateSelectionNotifier,
    this.onTap,
    // this.onChanged,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: TextField(
          enabled : enabled,
          style: const TextStyle(color: AppColors.white),
          controller: controller,
          readOnly: true,
          expands: true,
          maxLines: null,
          minLines: null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: label,
            hintStyle: const TextStyle(color: AppColors.white),
            prefixIcon:
                const Icon(Icons.calendar_month_outlined, color: AppColors.teal),
          ),
          onTap: onTap ?? () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2000),
              lastDate: DateTime.now(),
            );
        
            if (selectedDate != null) {
              controller.text = selectedDate.toIso8601String().split('T')[0].split('-').reversed.join('/');
            }
          },
          // onChanged: onChanged,
          // onSubmitted: onChanged,
        ),
      ),
    );
  }
}
