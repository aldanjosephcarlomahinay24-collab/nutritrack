import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../models/meal_type.dart';
import '../../models/recipe.dart';
import '../../viewmodels/meal_plan_view_model.dart';

class MealPlanView extends StatelessWidget {
  const MealPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MealPlanViewModel>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous week',
                onPressed: () => vm.changeWeek(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(vm.weekLabel, style: theme.textTheme.titleMedium),
                    Text(
                      '${vm.plannedThisWeek} of ${vm.slotsThisWeek} meals planned',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Next week',
                onPressed: () => vm.changeWeek(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final day in vm.days)
                Expanded(child: _DayChip(day: day, vm: vm)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(vm.selectedDayLabel,
                    style: theme.textTheme.titleMedium),
              ),
              Text('${vm.caloriesFor(vm.selectedDay)} kcal planned',
                  style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          for (final type in MealType.values) _SlotCard(type: type),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day, required this.vm});

  final DateTime day;
  final MealPlanViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = isSameDay(day, vm.selectedDay);
    final isToday = isSameDay(day, vm.today);
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => vm.selectDay(day),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(shortWeekday(day),
                    style: TextStyle(color: fg, fontSize: 12)),
                const SizedBox(height: 2),
                Text('${day.day}',
                    style: TextStyle(
                        color: fg,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: vm.hasPlan(day)
                        ? (selected ? scheme.onPrimary : scheme.primary)
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.type});

  final MealType type;

  Future<void> _pickRecipe(BuildContext context) async {
    final vm = context.read<MealPlanViewModel>();
    final recipe = await showModalBottomSheet<Recipe>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, controller) => ListView(
          controller: controller,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text('Pick ${type.label.toLowerCase()}',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final r in vm.recipesFor(type))
              ListTile(
                leading: Icon(r.mealType.icon),
                title: Text(r.name),
                subtitle: Text(
                    '${r.calories} kcal  ·  ${r.protein} g protein  ·  ${r.minutes} min'),
                onTap: () => Navigator.pop(context, r),
              ),
          ],
        ),
      ),
    );
    if (recipe != null) vm.assign(type, recipe);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MealPlanViewModel>();
    final planned = vm.mealFor(vm.selectedDay, type);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
          leading: CircleAvatar(child: Icon(type.icon, size: 20)),
          title: Text(type.label, style: theme.textTheme.labelLarge),
          subtitle: planned == null
              ? const Text('Nothing planned')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(planned.recipe.name,
                        style: theme.textTheme.titleMedium),
                    Text(
                        '${planned.recipe.calories} kcal  ·  ${planned.recipe.minutes} min'),
                  ],
                ),
          trailing: planned == null
              ? FilledButton.tonalIcon(
                  onPressed: () => _pickRecipe(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Swap',
                      onPressed: () => _pickRecipe(context),
                      icon: const Icon(Icons.swap_horiz),
                    ),
                    IconButton(
                      tooltip: 'Remove',
                      onPressed: () => vm.clear(type),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
