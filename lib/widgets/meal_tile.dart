import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/meal.dart';
import 'section_card.dart';

class MealTile extends StatelessWidget {
  const MealTile({
    super.key,
    required this.meal,
    this.onDelete,
    this.showTag = false,
  });

  final Meal meal;
  final VoidCallback? onDelete;
  final bool showTag;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(meal.eatenAt).format(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTag) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      border: Border.all(color: AppColors.ink, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      meal.type.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  showTag
                      ? '$time · ${meal.calories} kcal'
                      : '${meal.type.label} · $time',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Text(
            peso(meal.cost),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Delete meal',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: AppColors.ink),
            ),
        ],
      ),
    );
  }
}
