import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bottom_nav/navigation_cubit.dart';
import 'package:frontend/bottom_nav/widgets/app_navigation_bar.dart';
import 'package:frontend/bottom_nav/widgets/app_drawer.dart';
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
        appBar: AppBar(title: const Text("Carepulse")),
        extendBody: true,
        body: navigationShell,
        drawer: const AppDrawer(),
        bottomNavigationBar: AppNavigationBar(navigationShell: navigationShell),
      ),
    );
  }
}
