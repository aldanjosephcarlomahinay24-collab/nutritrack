import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../models/food_log_entry.dart';
import '../../models/meal_type.dart';
import '../../viewmodels/food_log_view_model.dart';
import '../../widgets/common.dart';
import 'log_meal_sheet.dart';

class FoodLogView extends StatelessWidget {
  const FoodLogView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FoodLogViewModel>();
    final entries = vm.entries;
    return Scaffold(
      appBar: AppBar(title: const Text('Food Log')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showLogMealSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log meal'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous day',
                onPressed: vm.previousDay,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  vm.dayLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Next day',
                onPressed: vm.canGoForward ? vm.nextDay : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatTile(
                    icon: Icons.payments_outlined,
                    label: 'Spent',
                    value: peso(vm.totalCost)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatTile(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Calories',
                    value: '${vm.totalCalories}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatTile(
                    icon: Icons.fitness_center,
                    label: 'Protein',
                    value: '${vm.totalProtein} g'),
              ),
            ],
          ),
          const SectionHeader('Meals'),
          if (entries.isEmpty)
            EmptyState(
              icon: Icons.no_meals_outlined,
              message: 'Nothing logged for ${vm.dayLabel.toLowerCase()}.',
              actionLabel: 'Log a meal',
              onAction: () => showLogMealSheet(context),
            )
          else
            for (final entry in entries) _LogTile(entry: entry),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final FoodLogEntry entry;

  void _delete(BuildContext context) {
    final vm = context.read<FoodLogViewModel>();
    final removed = vm.delete(entry.id);
    if (removed == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Deleted ${removed.name}'),
      action: SnackBarAction(label: 'Undo', onPressed: () => vm.undoDelete(removed)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final details = [
      clockTime(entry.time),
      if (entry.calories > 0) '${entry.calories} kcal',
      if (entry.protein > 0) '${entry.protein} g protein',
    ].join('  ·  ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete_outline),
        ),
        onDismissed: (_) => _delete(context),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(entry.mealType.icon, size: 20)),
            title: Text(entry.name),
            subtitle: Text('${entry.mealType.label}  ·  $details'),
            trailing: Text(peso(entry.cost),
                style: Theme.of(context).textTheme.titleSmall),
            onTap: () => showLogMealSheet(context, existing: entry),
          ),
        ),
      ),
    );
  }
}
