import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/shell_view_model.dart';
import '../discover/discover_view.dart';
import '../home/dashboard_view.dart';
import '../log/food_log_view.dart';
import '../pantry/pantry_view.dart';
import '../plan/meal_plan_view.dart';

/// Bottom navigation with the five main tabs. IndexedStack keeps each tab's
/// scroll position when switching.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[
    DashboardView(),
    MealPlanView(),
    FoodLogView(),
    PantryView(),
    DiscoverView(),
  ];

  @override
  Widget build(BuildContext context) {
    final shell = context.watch<ShellViewModel>();
    return Scaffold(
      body: IndexedStack(index: shell.current.index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.current.index,
        onDestinationSelected: (i) => shell.goTo(AppTab.values[i]),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Plan'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Log'),
          NavigationDestination(
              icon: Icon(Icons.kitchen_outlined),
              selectedIcon: Icon(Icons.kitchen),
              label: 'Pantry'),
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Discover'),
        ],
      ),
    );
  }
}
