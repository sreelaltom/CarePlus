import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bottom_nav/navigation_cubit.dart';
import 'package:frontend/bottom_nav/widgets/app_navigation_bar.dart';
import 'package:frontend/bottom_nav/widgets/app_drawer.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              NavigationCubit()..navigateTo(navigationShell.currentIndex),
        ),
        BlocProvider(
          create: (_) => MedicalRecordsBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Carepulse"),
          backgroundColor: AppColors.darkNavy,
        ),
        body: navigationShell,
        drawer: const AppDrawer(),
        bottomNavigationBar: AppNavigationBar(navigationShell: navigationShell),
      ),
    );
  }
}
