import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../core/formatters.dart';
import '../../core/meal_type_ui.dart';
import '../../models/meal_type.dart';
import '../../viewmodels/dashboard_view_model.dart';
import '../../viewmodels/shell_view_model.dart';
import '../../widgets/common.dart';
import '../log/log_meal_sheet.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final shell = context.read<ShellViewModel>();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.todayLabel, style: theme.textTheme.bodyMedium),
                      Text(vm.greeting, style: theme.textTheme.headlineSmall),
                    ],
                  ),
                ),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
                  child: CircleAvatar(radius: 24, child: Text(vm.initials)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            XpCard(
              level: vm.level,
              xp: vm.xp,
              progress: vm.levelProgress,
              xpToNext: vm.xpToNextLevel,
              streak: vm.streak,
              onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                      icon: Icons.payments_outlined,
                      label: 'Spent today',
                      value: peso(vm.todaySpend)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatTile(
                      icon: Icons.local_fire_department_outlined,
                      label: 'Calories',
                      value: '${vm.todayCalories}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatTile(
                      icon: Icons.fitness_center,
                      label: 'Protein',
                      value: '${vm.todayProtein} g'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text('This week: ${peso(vm.weekSpend)} on food',
                  style: theme.textTheme.bodySmall),
            ),
            SectionHeader(
              "Today's meals",
              actionLabel: 'See log',
              onAction: () => shell.goTo(AppTab.log),
            ),
            if (vm.todaysMeals.isEmpty)
              EmptyState(
                icon: Icons.no_meals_outlined,
                message: 'No meals logged yet today.',
                actionLabel: 'Log a meal',
                onAction: () => showLogMealSheet(context),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (final e in vm.todaysMeals)
                      ListTile(
                        leading: Icon(e.mealType.icon),
                        title: Text(e.name),
                        subtitle: Text(
                            '${clockTime(e.time)}  ·  ${e.calories} kcal'),
                        trailing: Text(peso(e.cost)),
                      ),
                  ],
                ),
              ),
            SectionHeader(
              'Planned for today',
              actionLabel: 'Open plan',
              onAction: () => shell.goTo(AppTab.plan),
            ),
            if (vm.plannedToday.isEmpty)
              const EmptyState(
                icon: Icons.calendar_today_outlined,
                message: 'Nothing planned today.',
              )
            else
              Card(
                child: Column(
                  children: [
                    for (final p in vm.plannedToday)
                      ListTile(
                        leading: Icon(p.mealType.icon),
                        title: Text(p.recipe.name),
                        subtitle: Text(
                            '${p.mealType.label}  ·  ${p.recipe.calories} kcal'),
                        trailing: TextButton(
                          onPressed: () => showLogMealSheet(
                            context,
                            presetName: p.recipe.name,
                            presetType: p.mealType,
                            presetCalories: p.recipe.calories,
                            presetProtein: p.recipe.protein,
                          ),
                          child: const Text('Log it'),
                        ),
                      ),
                  ],
                ),
              ),
            if (vm.lowStockCount > 0) ...[
              const SizedBox(height: 12),
              Card(
                color: theme.colorScheme.tertiaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text('${vm.lowStockCount} pantry items low or out'),
                  subtitle: const Text('Tap to check your pantry'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => shell.goTo(AppTab.pantry),
                ),
              ),
            ],
            const SectionHeader('Quick actions'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.6,
              children: [
                _QuickAction(
                  icon: Icons.add_circle_outline,
                  label: 'Log a meal',
                  onTap: () => showLogMealSheet(context),
                ),
                _QuickAction(
                  icon: Icons.soup_kitchen_outlined,
                  label: 'What can I make?',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.mealFinder),
                ),
                _QuickAction(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Shopping list',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.shoppingList),
                ),
                _QuickAction(
                  icon: Icons.storefront_outlined,
                  label: 'Campus Eats',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.campusEats),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
