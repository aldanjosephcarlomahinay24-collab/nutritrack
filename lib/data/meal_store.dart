import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/pantry_item.dart';

class DayTotals {
  const DayTotals(this.calories, this.protein, this.carbs, this.fat, this.cost);

  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double cost;
}

class MealStore extends ChangeNotifier {
  MealStore({
    this.userName = 'Aldan',
    this.dailyBudget = 250,
    this.calorieGoal = 2200,
    this.proteinGoal = 120,
    this.carbsGoal = 275,
    this.fatGoal = 70,
  });

  final String userName;
  final double dailyBudget;
  final int calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final List<Meal> _meals = [];
  final List<PantryItem> _pantry = [];
  int _nextId = 1;

  List<Meal> mealsOn(DateTime day) {
    final list = _meals
        .where((m) => DateUtils.isSameDay(m.eatenAt, day))
        .toList();
    list.sort((a, b) => a.eatenAt.compareTo(b.eatenAt));
    return list;
  }

  List<Meal> get todayMeals => mealsOn(DateTime.now());

  DayTotals totalsOn(DateTime day) {
    final meals = mealsOn(day);
    return DayTotals(
      meals.fold(0, (sum, m) => sum + m.calories),
      meals.fold(0.0, (sum, m) => sum + m.protein),
      meals.fold(0.0, (sum, m) => sum + m.carbs),
      meals.fold(0.0, (sum, m) => sum + m.fat),
      totalCost(meals),
    );
  }

  DayTotals get today => totalsOn(DateTime.now());
  double get todaySpend => today.cost;

  double get weekSpend {
    final start = DateUtils.dateOnly(DateTime.now())
        .subtract(const Duration(days: 6));
    return totalCost(_meals.where((m) => !m.eatenAt.isBefore(start)).toList());
  }

  List<int> calorieHistory(int days) {
    final today = DateUtils.dateOnly(DateTime.now());
    return [
      for (var i = days - 1; i >= 0; i--)
        totalsOn(today.subtract(Duration(days: i))).calories,
    ];
  }

  bool _loggedOn(DateTime day) => mealsOn(day).isNotEmpty;

  int get currentStreak {
    var day = DateUtils.dateOnly(DateTime.now());
    if (!_loggedOn(day)) day = day.subtract(const Duration(days: 1));
    var streak = 0;
    while (_loggedOn(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get bestStreak {
    if (_meals.isEmpty) return 0;
    final sorted =
        _meals.map((m) => DateUtils.dateOnly(m.eatenAt)).toSet().toList()
          ..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      run = sorted[i].difference(sorted[i - 1]).inDays == 1 ? run + 1 : 1;
      if (run > best) best = run;
    }
    return best;
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  List<PantryItem> get pantry => List.unmodifiable(_pantry);

  void addMeal({
    required String name,
    required MealType type,
    required DateTime eatenAt,
    required double cost,
    int calories = 0,
    double protein = 0,
    double carbs = 0,
    double fat = 0,
  }) {
    _meals.add(
      Meal(
        id: _nextId++,
        name: name,
        type: type,
        eatenAt: eatenAt,
        cost: cost,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
      ),
    );
    notifyListeners();
  }

  void updateMeal(Meal meal) {
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index == -1) return;
    _meals[index] = meal;
    notifyListeners();
  }

  void deleteMeal(int id) {
    _meals.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void addPantryItem(String name, int quantity) {
    _pantry.add(PantryItem(id: _nextId++, name: name, quantity: quantity));
    notifyListeners();
  }

  void removePantryItem(int id) {
    _pantry.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void loadSampleData() {
    final today = DateUtils.dateOnly(DateTime.now());
    const menu = [
      ('Pandesal + coffee', MealType.breakfast, 45.0, 380, 9.0, 62.0, 8.0),
      ('Tapsilog', MealType.breakfast, 85.0, 650, 32.0, 70.0, 24.0),
      ('Chicken adobo + rice', MealType.lunch, 95.0, 620, 34.0, 68.0, 20.0),
      ('Pork sinigang + rice', MealType.lunch, 90.0, 560, 28.0, 66.0, 18.0),
      ('Tortang talong + rice', MealType.dinner, 60.0, 480, 16.0, 62.0, 17.0),
      ('Ginisang monggo + rice', MealType.dinner, 55.0, 520, 22.0, 80.0, 9.0),
      ('Banana cue', MealType.snack, 25.0, 240, 1.5, 48.0, 6.0),
    ];
    const pattern = [3, 2, 3, 1, 3, 2, 3, 2, 0, 1, 0, 3, 2, 2];
    for (var d = 13; d >= 1; d--) {
      final count = pattern[13 - d];
      for (var i = 0; i < count; i++) {
        final item = menu[(d * 3 + i * 2) % menu.length];
        _meals.add(
          Meal(
            id: _nextId++,
            name: item.$1,
            type: item.$2,
            eatenAt: today
                .subtract(Duration(days: d))
                .add(Duration(hours: 7 + i * 5)),
            cost: item.$3,
            calories: item.$4,
            protein: item.$5,
            carbs: item.$6,
            fat: item.$7,
          ),
        );
      }
    }
    addMeal(
      name: 'Pandesal + coffee',
      type: MealType.breakfast,
      eatenAt: today.add(const Duration(hours: 7, minutes: 30)),
      cost: 45,
      calories: 380,
      protein: 9,
      carbs: 62,
      fat: 8,
    );
    addMeal(
      name: 'Boiled eggs (2)',
      type: MealType.breakfast,
      eatenAt: today.add(const Duration(hours: 7, minutes: 35)),
      cost: 24,
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
    );
    addMeal(
      name: 'Chicken adobo + rice',
      type: MealType.lunch,
      eatenAt: today.add(const Duration(hours: 12, minutes: 10)),
      cost: 95,
      calories: 620,
      protein: 34,
      carbs: 68,
      fat: 20,
    );
    addPantryItem('Rice', 2);
    addPantryItem('Eggs', 6);
    addPantryItem('Eggplant', 3);
    addPantryItem('Instant noodles', 4);
  }
}

double totalCost(List<Meal> meals) => meals.fold(0.0, (sum, m) => sum + m.cost);
