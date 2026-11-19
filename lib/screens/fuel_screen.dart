import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../data/meal_store.dart';
import '../models/meal.dart';
import '../widgets/charts.dart';
import '../widgets/meal_tile.dart';
import '../widgets/section_card.dart';
import 'log_meal_screen.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key, required this.store});

  final MealStore store;

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  DateTime day = DateUtils.dateOnly(DateTime.now());

  bool get _isToday => DateUtils.isSameDay(day, DateTime.now());

  String get _dayLabel {
    if (_isToday) return 'Today';
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (DateUtils.isSameDay(day, yesterday)) return 'Yesterday';
    return '${day.month}/${day.day}';
  }

  void _shiftDay(int days) {
    final next = day.add(Duration(days: days));
    if (next.isAfter(DateTime.now())) return;
    setState(() => day = next);
  }

  Future<void> _openForm({Meal? meal, MealType? type}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LogMealScreen(
          store: widget.store,
          meal: meal,
          initialType: type,
          day: day,
        ),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(meal == null ? 'Meal logged' : 'Meal updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final meals = store.mealsOn(day);
        final totals = store.totalsOn(day);
        final remaining = store.calorieGoal - totals.calories;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            ScreenHeader(
              title: 'Fuel',
              actions: [
                RoundIconButton(
                  icon: Icons.add,
                  tooltip: 'Log a meal',
                  onPressed: () => _openForm(),
                ),
              ],
            ),
            SectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              radius: 40,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _shiftDay(-1),
                    icon: const Icon(Icons.chevron_left, size: 30),
                  ),
                  Expanded(
                    child: Text(
                      _dayLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isToday ? null : () => _shiftDay(1),
                    icon: const Icon(Icons.chevron_right, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SectionCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      CalorieRing(
                        value: totals.calories,
                        goal: store.calorieGoal,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          children: [
                            _KeyValue('Goal', '${store.calorieGoal} kcal'),
                            const SizedBox(height: 12),
                            _KeyValue(
                              remaining >= 0 ? 'Left' : 'Over',
                              '${remaining.abs()} kcal',
                            ),
                            const SizedBox(height: 12),
                            _KeyValue('Spent', peso(totals.cost)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: MacroChip(
                          label: 'Protein',
                          value: totals.protein,
                          goal: store.proteinGoal,
                          color: AppColors.blueSoft,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MacroChip(
                          label: 'Carbs',
                          value: totals.carbs,
                          goal: store.carbsGoal,
                          color: AppColors.blueMid,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MacroChip(
                          label: 'Fat',
                          value: totals.fat,
                          goal: store.fatGoal,
                          color: AppColors.blueLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('14-day history'),
                  const SizedBox(height: 18),
                  HistoryChart(
                    values: store.calorieHistory(14),
                    endDay: DateTime.now(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(_isToday ? "Today's meals" : 'Meals'),
                  const SizedBox(height: 8),
                  for (final type in MealType.values)
                    _MealGroup(
                      type: type,
                      meals: meals.where((m) => m.type == type).toList(),
                      onAdd: () => _openForm(type: type),
                      onEdit: (meal) => _openForm(meal: meal),
                      onDelete: (meal) => store.deleteMeal(meal.id),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.muted),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: monoFont,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MealGroup extends StatelessWidget {
  const _MealGroup({
    required this.type,
    required this.meals,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final MealType type;
  final List<Meal> meals;
  final VoidCallback onAdd;
  final ValueChanged<Meal> onEdit;
  final ValueChanged<Meal> onDelete;

  @override
  Widget build(BuildContext context) {
    final kcal = meals.fold(0, (sum, m) => sum + m.calories);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                type.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$kcal kcal',
                style: const TextStyle(
                  fontFamily: monoFont,
                  fontSize: 15,
                  color: AppColors.muted,
                ),
              ),
              const Spacer(),
              RoundIconButton(
                icon: Icons.add,
                tooltip: 'Add ${type.label.toLowerCase()}',
                size: 38,
                shadow: false,
                onPressed: onAdd,
              ),
            ],
          ),
          for (final meal in meals)
            MealTile(
              meal: meal,
              onEdit: () => onEdit(meal),
              onDelete: () => onDelete(meal),
            ),
        ],
      ),
    );
  }
}
