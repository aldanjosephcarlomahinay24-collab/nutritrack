import 'package:flutter/material.dart';

import '../../core/app_routes.dart';

/// Hub for the screens that sit on top of the main tabs.
class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  static const _entries = [
    (Icons.soup_kitchen_outlined, 'What can I make?',
        'Pick what you have, get meals you can cook.', AppRoutes.mealFinder),
    (Icons.shopping_cart_outlined, 'Shopping list',
        'Built from your plan minus your pantry.', AppRoutes.shoppingList),
    (Icons.storefront_outlined, 'Campus Eats',
        'Cheap meals near school, sorted by price.', AppRoutes.campusEats),
    (Icons.emoji_events_outlined, 'Progress and badges',
        'XP, level, streak and achievements.', AppRoutes.progress),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: _entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (icon, title, subtitle, route) = _entries[i];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(child: Icon(icon)),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, route),
            ),
          );
        },
      ),
    );
  }
}
