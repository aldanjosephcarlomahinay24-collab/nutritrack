import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../viewmodels/meal_finder_view_model.dart';
import '../../widgets/common.dart';
import '../log/log_meal_sheet.dart';

class MealFinderView extends StatelessWidget {
  const MealFinderView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MealFinderViewModel>();
    final ready = vm.readyToCook;
    final almost = vm.almostThere;
    return Scaffold(
      appBar: AppBar(title: const Text('What can I make?')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${vm.selected.length} ingredients picked',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              TextButton(onPressed: vm.useMyPantry, child: const Text('Use my pantry')),
              TextButton(onPressed: vm.clearSelection, child: const Text('Clear')),
            ],
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final ing in vm.ingredientOptions)
                FilterChip(
                  avatar: vm.isInPantry(ing)
                      ? const Icon(Icons.kitchen_outlined, size: 16)
                      : null,
                  label: Text(ing),
                  selected: vm.selected.contains(ing),
                  onSelected: (_) => vm.toggle(ing),
                ),
            ],
          ),
          SectionHeader('Ready to cook (${ready.length})'),
          if (ready.isEmpty)
            const EmptyState(
              icon: Icons.search_off,
              message: 'No full matches yet. Pick more ingredients.',
            )
          else
            for (final m in ready) _MatchCard(match: m),
          SectionHeader('Missing 1 or 2 things (${almost.length})'),
          for (final m in almost) _MatchCard(match: m),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});

  final RecipeMatch match;

  @override
  Widget build(BuildContext context) {
    final r = match.recipe;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: CircleAvatar(child: Icon(r.mealType.icon, size: 20)),
          title: Text(r.name),
          subtitle: Text(match.canMake
              ? '${r.minutes} min  ·  ${r.calories} kcal'
              : 'Need: ${match.missing.join(', ')}'),
          trailing: match.canMake
              ? Icon(Icons.check_circle, color: scheme.primary)
              : Text('${match.have.length}/${r.ingredients.length}'),
          onTap: () => _showDetails(context),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final vm = context.read<MealFinderViewModel>();
    vm.open(match.recipe);
    final r = match.recipe;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(r.name, style: theme.textTheme.titleLarge),
              Text('${r.minutes} min  ·  ${r.calories} kcal  ·  ${r.protein} g protein'),
              const SizedBox(height: 12),
              for (final ing in r.ingredients)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    match.missing.contains(ing)
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: match.missing.contains(ing)
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary,
                  ),
                  title: Text(capitalize(ing)),
                ),
              const SizedBox(height: 12),
              if (!match.canMake)
                OutlinedButton.icon(
                  onPressed: () {
                    final added = vm.addMissingToShopping(match);
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Added $added item(s) to shopping list'),
                    ));
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add missing to shopping list'),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  showLogMealSheet(
                    context,
                    presetName: r.name,
                    presetType: r.mealType,
                    presetCalories: r.calories,
                    presetProtein: r.protein,
                  );
                },
                icon: const Icon(Icons.restaurant),
                label: const Text('I made this, log it'),
              ),
            ],
          ),
        );
      },
    );
  }
}
