import 'meal_type.dart';

/// A meal the app can suggest. Ingredient names are lowercase so they can be
/// matched against pantry items.
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.mealType,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.minutes,
  });

  final String id;
  final String name;
  final MealType mealType;
  final List<String> ingredients;
  final int calories;
  final int protein;
  final int minutes;
}
