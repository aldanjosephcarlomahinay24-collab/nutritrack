import 'package:flutter/material.dart';

import '../data/meal_store.dart';
import '../widgets/pop_nav_bar.dart';
import 'fuel_screen.dart';
import 'meal_plan_screen.dart';
import 'pantry_screen.dart';
import 'today_screen.dart';

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
      TodayScreen(store: widget.store),
      FuelScreen(store: widget.store),
      const MealPlanScreen(),
      PantryScreen(store: widget.store),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: selectedIndex, children: screens),
      ),
      bottomNavigationBar: PopNavBar(
        selectedIndex: selectedIndex,
        onSelected: (i) => setState(() => selectedIndex = i),
        items: const [
          PopNavItem(Icons.wb_sunny_outlined, 'Today'),
          PopNavItem(Icons.local_fire_department_outlined, 'Fuel'),
          PopNavItem(Icons.calendar_month_outlined, 'Plan'),
          PopNavItem(Icons.kitchen_outlined, 'Pantry'),
        ],
      ),
    );
  }
}
