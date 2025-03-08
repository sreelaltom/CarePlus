import 'package:flutter/widgets.dart';
import 'package:frontend/core/constants/navigation_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/bottom_nav/widgets/app_navigation_bar_item.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final double height;
  final int selectedIndex;
  // final void Function(int) onDestinationChanged;
  const AppNavigationBar({
    super.key,
    this.selectedIndex = 0,
    this.height = 70,
    // required this.onDestinationChanged,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkNavy, // AppColors.lightGrey.withValues(alpha: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: NavigationConstants.navBarData
              .map(
                (navBarItemData) => AppNavigationBarItem(
                  index: navBarItemData["index"] as int,
                  icon: Icon(navBarItemData["icon"] as IconData,
                      color: AppColors.teal //primary,
                      ),
                  selectedIcon: Icon(
                      navBarItemData["selected_icon"] as IconData,
                      color: AppColors.teal //primary,
                      ),
                  label: navBarItemData["label"] as String,
                  labelColor: AppColors.teal,
                  navigationShell: navigationShell,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
