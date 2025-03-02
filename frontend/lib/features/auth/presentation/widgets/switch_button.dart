import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/core/theme/app_colors.dart';

class SwitchButton extends StatelessWidget {
  final String label;
  final FontWeight? labelWeight;
  final double? labelSize;
  final Color borderColor;
  final VoidCallback? onTap;
  // late final bool _ifSelected;

  const SwitchButton({
    super.key,
    required this.label,
    this.labelWeight,
    this.labelSize = 20,
    this.borderColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            (previous is AuthInitial && current is UserAuthState) ||
            (previous is UserAuthState && current is DoctorAuthState) ||
            (previous is DoctorAuthState && current is UserAuthState),
        builder: (context, state) {
          late final ifSelected = label == 'Doctor'
              ? (state is DoctorAuthState ? true : false)
              : (state is UserAuthState ? true : false);
          return GestureDetector(
            onTap: !ifSelected ? onTap : null,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: ifSelected ? AppColors.primary : AppColors.transparent,
                border: !ifSelected
                    ? Border.all(color: borderColor, width: 2)
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: ifSelected ? AppColors.teal : AppColors.primary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
