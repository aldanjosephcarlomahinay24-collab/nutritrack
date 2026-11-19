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
  final double protein;
  final double carbs;
  final double fat;

  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.eatenAt,
    required this.cost,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  Meal copyWith({
    String? name,
    MealType? type,
    DateTime? eatenAt,
    double? cost,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    return Meal(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      eatenAt: eatenAt ?? this.eatenAt,
      cost: cost ?? this.cost,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
