import 'meal_type.dart';

/// One meal the user actually ate.
class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.name,
    required this.mealType,
    required this.time,
    required this.cost,
    this.calories = 0,
    this.protein = 0,
  });

  final String id;
  final String name;
  final MealType mealType;
  final DateTime time;
  final double cost;
  final int calories;
  final int protein;

  FoodLogEntry copyWith({
    String? name,
    MealType? mealType,
    DateTime? time,
    double? cost,
    int? calories,
    int? protein,
  }) {
    return FoodLogEntry(
      id: id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      time: time ?? this.time,
      cost: cost ?? this.cost,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
    );
  }
}
