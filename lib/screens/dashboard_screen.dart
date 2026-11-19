import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import '../widgets/meal_tile.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store});

  final MealStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final meals = store.todayMeals;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 72,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NUTRITRACK'),
                Text(
                  '${store.greeting}, ${store.userName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              SectionCard(
                color: AppColors.pink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label('Spent today'),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          peso(store.todaySpend),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            '/ ${peso(store.dailyBudget)} budget',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.ink, width: 2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: store.budgetProgress,
                        child: Container(color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      color: AppColors.blue,
                      label: 'This week',
                      value: peso(store.weekSpend),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      color: Colors.white,
                      label: 'Calories',
                      value: '${store.todayCalories}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label("Today's meals"),
                    if (meals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No meals logged yet today.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    for (final meal in meals) MealTile(meal: meal),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
