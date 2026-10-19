import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/progress_view_model.dart';
import '../../widgets/common.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProgressViewModel>();
    final theme = Theme.of(context);
    final stats = [
      (Icons.restaurant, 'Meals logged', vm.mealsLogged),
      (Icons.calendar_month, 'Meals planned', vm.mealsPlanned),
      (Icons.kitchen_outlined, 'Pantry items', vm.pantryItems),
      (Icons.explore_outlined, 'Meals discovered', vm.mealsDiscovered),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
                radius: 24, child: Text(vm.name.substring(0, 1).toUpperCase())),
            title: Text(vm.name, style: theme.textTheme.titleLarge),
            subtitle: Text('${vm.campus}  ·  local profile'),
          ),
          const SizedBox(height: 8),
          XpCard(
            level: vm.level,
            xp: vm.xp,
            progress: vm.levelProgress,
            xpToNext: vm.xpToNextLevel,
            streak: vm.streak,
          ),
          const SectionHeader('Stats'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.7,
            children: [
              for (final (icon, label, value) in stats)
                StatTile(icon: icon, label: label, value: '$value'),
            ],
          ),
          SectionHeader(
              'Achievements (${vm.unlockedCount}/${vm.achievements.length})'),
          Card(
            child: Column(
              children: [
                for (final a in vm.achievements)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: vm.isUnlocked(a)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      foregroundColor: vm.isUnlocked(a)
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.outline,
                      child: Icon(vm.isUnlocked(a)
                          ? Icons.emoji_events
                          : Icons.lock_outline),
                    ),
                    title: Text(a.title),
                    subtitle: Text(a.description),
                    trailing: Text('+${a.xpReward} XP',
                        style: theme.textTheme.labelMedium),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
