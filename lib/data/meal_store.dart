import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/pantry_item.dart';

class MealStore extends ChangeNotifier {
  MealStore({this.userName = 'Aldan', this.dailyBudget = 250});

  final String userName;
  final double dailyBudget;
  final List<Meal> _meals = [];
  final List<PantryItem> _pantry = [];
  int _nextId = 1;

  List<Meal> get todayMeals {
    final now = DateTime.now();
    final list = _meals
        .where((m) => DateUtils.isSameDay(m.eatenAt, now))
        .toList();
    list.sort((a, b) => b.eatenAt.compareTo(a.eatenAt));
    return list;
  }

  List<Meal> get weekMeals {
    final start = DateUtils.dateOnly(DateTime.now())
        .subtract(const Duration(days: 6));
    return _meals.where((m) => !m.eatenAt.isBefore(start)).toList();
  }

  double get todaySpend => totalCost(todayMeals);
  double get weekSpend => totalCost(weekMeals);
  int get todayCalories => todayMeals.fold(0, (sum, m) => sum + m.calories);
  double get budgetProgress => (todaySpend / dailyBudget).clamp(0.0, 1.0);

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
  }) {
    _meals.add(
      Meal(
        id: _nextId++,
        name: name,
        type: type,
        eatenAt: eatenAt,
        cost: cost,
        calories: calories,
      ),
    );
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
    addMeal(
      name: 'Pandesal + coffee',
      type: MealType.breakfast,
      eatenAt: today.add(const Duration(hours: 7, minutes: 30)),
      cost: 45,
      calories: 380,
    );
    addMeal(
      name: 'Chicken adobo + rice',
      type: MealType.lunch,
      eatenAt: today.add(const Duration(hours: 12, minutes: 10)),
      cost: 95,
      calories: 620,
    );
    addMeal(
      name: 'Banana cue',
      type: MealType.snack,
      eatenAt: today.add(const Duration(hours: 15, minutes: 40)),
      cost: 45,
      calories: 240,
    );
    addMeal(
      name: 'Pork sinigang + rice',
      type: MealType.lunch,
      eatenAt: today.subtract(const Duration(days: 1, hours: -12)),
      cost: 90,
      calories: 560,
    );
    addPantryItem('Rice', 2);
    addPantryItem('Eggs', 6);
    addPantryItem('Eggplant', 3);
    addPantryItem('Instant noodles', 4);
  }
}

double totalCost(List<Meal> meals) => meals.fold(0.0, (sum, m) => sum + m.cost);
