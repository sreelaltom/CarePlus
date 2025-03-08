import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/bottom_nav/navigation_cubit.dart';
import 'package:frontend/bottom_nav/widgets/app_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NavigationCubit()..navigateTo(navigationShell.currentIndex),
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(Icons.menu),
          title: Text("Carepulse"),
        ),
        extendBody: true,
        body: navigationShell,
        drawer: Drawer(
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
              ListTile(
                tileColor: AppColors.darkNavy,
                onTap: () => _logoutUser(context),
                leading: Icon(
                  Icons.logout_outlined,
                  color: AppColors.error,
                ),
                title: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.teal,
                      ),
                ),
              )
              // DrawerButton()
            ],
          ),
        ),
        bottomNavigationBar: AppNavigationBar(navigationShell: navigationShell),
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
