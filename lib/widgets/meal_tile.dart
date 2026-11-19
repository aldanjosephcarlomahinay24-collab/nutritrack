import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/meal.dart';
import 'section_card.dart';

class MealTile extends StatelessWidget {
  const MealTile({super.key, required this.meal, this.onEdit, this.onDelete});

  final Meal meal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 0, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${peso(meal.cost)} · P:${grams(meal.protein)} · '
                  'C:${grams(meal.carbs)} · F:${grams(meal.fat)}',
                  style: const TextStyle(
                    fontFamily: monoFont,
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${meal.calories}',
            style: const TextStyle(
              fontFamily: monoFont,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 22),
            ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 22),
            ),
        ],
      ),
    );
  }
}
