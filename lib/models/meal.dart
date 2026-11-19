enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String get label => name[0].toUpperCase() + name.substring(1);
}

class Meal {
  final int id;
  final String name;
  final MealType type;
  final DateTime eatenAt;
  final double cost;
  final int calories;

  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.eatenAt,
    required this.cost,
    required this.calories,
  });
}
