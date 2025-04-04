import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final ValueNotifier<T> selectionNotifier;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;
  final double borderRadius;
  const AppDropdown({
    super.key,
    required this.selectionNotifier,
    required this.items,
    this.borderRadius = 5,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectionNotifier,
      builder: (_, selectedValue, __) {
        return DropdownButtonFormField<T>(
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.white),
          dropdownColor: AppColors.primary,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
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
          value: selectedValue,
          onChanged: onChanged ?? (value) => selectionNotifier.value = value as T,
          items: items,
        );
      },
    );
  }
}
