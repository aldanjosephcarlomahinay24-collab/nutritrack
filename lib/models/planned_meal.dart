import 'meal_type.dart';
import 'recipe.dart';

/// A recipe slotted into one meal of one day in the weekly plan.
class PlannedMeal {
  const PlannedMeal({
    required this.day,
    required this.mealType,
    required this.recipe,
  });

  final DateTime day;
  final MealType mealType;
  final Recipe recipe;
}
