import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bottom_nav/widgets/app_drawer_item.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: AppColors.darkNavy,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 4,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.lightGrey,
                    radius: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "User",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.teal),
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    "user@gmail.com",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.teal),
                  ),
                ],
              ),
            ),
          ),
          AppDrawerItem(
              icon: Icon(Icons.settings_outlined, color: AppColors.teal),
              label: "Settings",
              onTap: () {}),
          AppDrawerItem(
              icon: Icon(Icons.logout_outlined, color: AppColors.error),
              label: "Logout",
              onTap: () => _logoutUser(context)),
          // DrawerButton()
        ],
      ),
    );
  }
}

void _logoutUser(BuildContext context) async {
  await context.read<SessionCubit>().terminateSession(isLogout: true);
  if (context.mounted) {
    context.goNamed(RouteNames.login);
  }
}
