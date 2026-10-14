import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/features/articles/presentation/pages/articles_screen.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gymnestic/features/dashboard/presentation/pages/home_screen.dart';
import 'package:gymnestic/features/profile/presentation/pages/profile_screen.dart';
import 'package:gymnestic/features/statistics/presentation/pages/statistics_screen.dart';

class DashboardShellScreen extends GetView<DashboardController> {
  const DashboardShellScreen({super.key});

  static const _pages = <Widget>[
    HomeScreen(),
    StatisticsScreen(),
    ArticlesScreen(),
    ProfileScreen(),
  ];

  static const _items = <_NavigationItem>[
    _NavigationItem(Icons.home_filled, 'Home'),
    _NavigationItem(Icons.bar_chart_rounded, 'Statistics'),
    _NavigationItem(Icons.menu_book_rounded, 'Articles'),
    _NavigationItem(Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Obx(
      () => IndexedStack(
        index: controller.currentTabIndex.value,
        children: _pages,
      ),
    ),
    bottomNavigationBar: Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(top: BorderSide(color: Color(0xFF202020))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: List.generate(_items.length, (index) {
                final selected = controller.currentTabIndex.value == index;
                final item = _items[index];
                return Expanded(
                  child: InkWell(
                    onTap: () => controller.selectTab(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 22,
                          color: selected
                              ? AppColors.primaryRed
                              : AppColors.grayMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 9,
                            color: selected
                                ? AppColors.primaryRed
                                : AppColors.grayMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NavigationItem {
  const _NavigationItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
