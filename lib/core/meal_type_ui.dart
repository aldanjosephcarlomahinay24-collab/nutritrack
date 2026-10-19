import 'package:flutter/material.dart';

import '../models/meal_type.dart';

extension MealTypeIcon on MealType {
  IconData get icon => switch (this) {
        MealType.breakfast => Icons.free_breakfast_outlined,
        MealType.lunch => Icons.lunch_dining_outlined,
        MealType.dinner => Icons.dinner_dining_outlined,
        MealType.snack => Icons.cookie_outlined,
      };
}
