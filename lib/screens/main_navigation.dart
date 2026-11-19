import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import 'dashboard_screen.dart';
import 'food_log_screen.dart';
import 'meal_plan_screen.dart';
import 'pantry_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.store});

  final MealStore store;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(store: widget.store),
      FoodLogScreen(store: widget.store),
      const MealPlanScreen(),
      PantryScreen(store: widget.store),
    ];
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: popBorder)),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) => setState(() => selectedIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              selectedIcon: Icon(Icons.restaurant),
              label: 'Food Log',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Meal Plan',
            ),
            NavigationDestination(
              icon: Icon(Icons.kitchen_outlined),
              selectedIcon: Icon(Icons.kitchen),
              label: 'Pantry',
            ),
          ],
        ),
      ),
    );
  }
}
