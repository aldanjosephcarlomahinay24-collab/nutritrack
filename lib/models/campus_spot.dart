import 'meal_type.dart';

/// An affordable place to eat near campus. Entered by hand for now (no map API).
class CampusSpot {
  const CampusSpot({
    required this.name,
    required this.dish,
    required this.price,
    required this.mealType,
    required this.walkMinutes,
    required this.hours,
  });

  final String name;
  final String dish;
  final double price;
  final MealType mealType;
  final int walkMinutes;
  final String hours;
}
