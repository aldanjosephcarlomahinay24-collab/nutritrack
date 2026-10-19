import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../models/meal_type.dart';
import '../../viewmodels/campus_eats_view_model.dart';
import '../../widgets/common.dart';

class CampusEatsView extends StatelessWidget {
  const CampusEatsView({super.key});

  static const _sortLabels = {
    CampusSort.cheapest: 'Cheapest',
    CampusSort.priciest: 'Priciest',
    CampusSort.nearest: 'Nearest',
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CampusEatsViewModel>();
    final theme = Theme.of(context);
    final spots = vm.spots;
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Eats')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Card(
            color: theme.colorScheme.secondaryContainer,
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('15 spots near campus'),
              subtitle: Text('Entered by hand. Map comes later.'),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<CampusSort>(
            segments: [
              for (final s in CampusSort.values)
                ButtonSegment(value: s, label: Text(_sortLabels[s]!)),
            ],
            selected: {vm.sort},
            onSelectionChanged: (s) => vm.setSort(s.first),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Any meal'),
                  selected: vm.mealType == null,
                  onSelected: (_) => vm.setMealType(null),
                ),
                for (final t in MealType.values)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Text(t.label),
                      selected: vm.mealType == t,
                      onSelected: (_) => vm.setMealType(t),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final b in CampusEatsViewModel.budgets)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(b == null ? 'Any price' : 'Under ${peso(b)}'),
                      selected: vm.maxBudget == b,
                      onSelected: (_) => vm.setMaxBudget(b),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (spots.isEmpty)
            const EmptyState(
              icon: Icons.storefront_outlined,
              message: 'Nothing matches. Try a bigger budget.',
            )
          else
            for (final s in spots)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(s.mealType.icon, size: 20)),
                    title: Text(s.dish),
                    subtitle: Text(
                        '${s.name}\n${s.walkMinutes} min walk  ·  ${s.hours}'),
                    isThreeLine: true,
                    trailing: Text(peso(s.price),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.primary)),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
