import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/config/session_manager.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_button.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  final String userID;
  final String accessToken;
  final String refreshToken;

  const DashboardPage({
    super.key,
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.black,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          const Text('Dashboard'),
          AuthButton(
            label: 'Sign out',
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.teal,
            ),
            onPressed: () async {
              // SessionManager().clearSession();
              context.read<AuthBloc>().add(LogoutEvent(context: context));
              // context.read<AuthBloc>().add(SessionExpiredEvent());
            },
          ),
        ],
      )),
    );
  }
}
