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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        const ScreenHeader(eyebrow: 'This week', title: 'Meal plan'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final day in days)
              ChoiceChip(
                label: Text(day),
                selected: selectedDay == day,
                showCheckmark: false,
                onSelected: (_) => setState(() => selectedDay = day),
              ),
          ],
        ),
        const SizedBox(height: 22),
        for (final (i, meal) in meals.indexed) ...[
          SectionCard(
            color: [AppColors.blueSoft, Colors.white, AppColors.pink][i],
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(meal.slot),
                      const SizedBox(height: 8),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      peso(meal.cost),
                      style: const TextStyle(
                        fontFamily: monoFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Pill(meal.source.toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Planned',
                value: peso(total),
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: StatCard(label: 'Budget', value: '₱250'),
            ),
          ],
        ),
      ],
    );
  }
}
