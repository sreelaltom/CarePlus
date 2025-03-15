import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bottom_nav/navigation_cubit.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBarItem extends StatelessWidget {
  final int index;
  final double height;
  final Widget icon;
  final Widget selectedIcon;
  final Color labelColor;
  final Color? labelSelectedColor;
  final String label;
  // final ValueChanged<int> onSelected;
  final StatefulNavigationShell navigationShell;

  const AppNavigationBarItem({
    super.key,
    this.height = 70,
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.labelColor,
    this.labelSelectedColor,
    // required this.onSelected,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<NavigationCubit>().navigateTo(index);
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        child: SizedBox.fromSize(
          size: Size(height, height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              BlocBuilder<NavigationCubit, int>(
                buildWhen: (previous, current) =>
                    previous != current &&
                    (current == index || previous == index),
                builder: (context, state) =>
                    state == index ? selectedIcon : icon,
              ),
              BlocBuilder<NavigationCubit, int>(
                buildWhen: (previous, current) =>
                    previous != current &&
                    (current == index || previous == index),
                builder: (context, state) {
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: labelSelectedColor == null ? labelColor : (state == index ? labelSelectedColor : labelColor),
                          fontWeight: state == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
