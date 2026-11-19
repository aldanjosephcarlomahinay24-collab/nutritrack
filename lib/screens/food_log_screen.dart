import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import '../widgets/meal_tile.dart';
import '../widgets/section_card.dart';
import 'log_meal_screen.dart';

class FoodLogScreen extends StatelessWidget {
  const FoodLogScreen({super.key, required this.store});

  final MealStore store;

  Future<void> _openLogMeal(BuildContext context) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => LogMealScreen(store: store)),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Meal logged')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final meals = store.todayMeals;
        return Scaffold(
          appBar: AppBar(title: const Text('FOOD LOG')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              PopButton(
                label: 'Log a meal',
                icon: Icons.add,
                onPressed: () => _openLogMeal(context),
              ),
              const SizedBox(height: 18),
              SectionCard(
                padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
                child: meals.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Nothing logged today. Tap "Log a meal" to start.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    : Column(
                        children: [
                          for (final meal in meals)
                            MealTile(
                              meal: meal,
                              showTag: true,
                              onDelete: () => store.deleteMeal(meal.id),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Meals',
                      value: '${meals.length}',
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      color: AppColors.pink,
                      label: 'Spent today',
                      value: peso(store.todaySpend),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
