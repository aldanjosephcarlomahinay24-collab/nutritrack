import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets/section_card.dart';

class PlannedMeal {
  const PlannedMeal(this.slot, this.name, this.cost, this.source);

  final String slot;
  final String name;
  final double cost;
  final String source;
}

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  static const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  static const plan = {
    'Mon': [
      PlannedMeal('Breakfast', 'Champorado', 35, 'from pantry'),
      PlannedMeal('Lunch', 'Pork sinigang + rice', 90, 'campus'),
      PlannedMeal('Dinner', 'Tortang talong', 40, 'from pantry'),
    ],
    'Tue': [
      PlannedMeal('Breakfast', 'Egg + rice', 30, 'from pantry'),
      PlannedMeal('Lunch', 'Chicken adobo + rice', 95, 'campus'),
      PlannedMeal('Dinner', 'Pancit canton', 45, 'from pantry'),
    ],
    'Wed': [
      PlannedMeal('Breakfast', 'Pandesal + coffee', 45, 'bakery'),
      PlannedMeal('Lunch', 'Lumpia + rice', 80, 'campus'),
      PlannedMeal('Dinner', 'Ginisang monggo', 50, 'from pantry'),
    ],
    'Thu': [
      PlannedMeal('Breakfast', 'Oatmeal', 25, 'from pantry'),
      PlannedMeal('Lunch', 'Fried fish + rice', 85, 'campus'),
      PlannedMeal('Dinner', 'Egg fried rice', 35, 'from pantry'),
    ],
    'Fri': [
      PlannedMeal('Breakfast', 'Banana + bread', 30, 'from pantry'),
      PlannedMeal('Lunch', 'Bicol express + rice', 95, 'campus'),
      PlannedMeal('Dinner', 'Sardines + rice', 40, 'from pantry'),
    ],
  };

  String selectedDay = 'Mon';

  @override
  Widget build(BuildContext context) {
    final meals = plan[selectedDay]!;
    final total = meals.fold(0.0, (sum, m) => sum + m.cost);
    return Scaffold(
      appBar: AppBar(title: const Text('MEAL PLAN')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final day in days)
                ChoiceChip(
                  label: Text(day),
                  selected: selectedDay == day,
                  onSelected: (_) => setState(() => selectedDay = day),
                ),
            ],
          ),
          const SizedBox(height: 14),
          for (final (i, meal) in meals.indexed) ...[
            SectionCard(
              color: [AppColors.pink, Colors.white, AppColors.blue][i],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(meal.slot),
                  const SizedBox(height: 6),
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${peso(meal.cost)} · ${meal.source}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Planned today',
                  value: peso(total),
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: StatCard(
                  label: 'Budget',
                  value: '₱250',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
