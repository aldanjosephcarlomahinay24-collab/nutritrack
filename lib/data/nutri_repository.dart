import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/formatters.dart';
import '../models/achievement.dart';
import '../models/campus_spot.dart';
import '../models/food_log_entry.dart';
import '../models/meal_type.dart';
import '../models/pantry_item.dart';
import '../models/planned_meal.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../models/user_profile.dart';
import '../services/gamification_service.dart';
import 'mock_data.dart';

/// Single source of truth for app data (the Model layer in MVVM).
///
/// Data lives in memory for this checkpoint. Every change goes through
/// [_commit], which applies XP, unlocks achievements and notifies the
/// view models listening to this repository. Swapping in local storage later
/// only touches this class.
class NutriRepository extends ChangeNotifier {
  NutriRepository({
    required this.profile,
    required List<Recipe> recipes,
    required List<CampusSpot> campusSpots,
    required List<Achievement> achievements,
    List<FoodLogEntry> logs = const [],
    List<PantryItem> pantry = const [],
    List<PlannedMeal> plan = const [],
    List<ShoppingItem> shopping = const [],
    Set<String> discoveredRecipeIds = const {},
    int xp = 0,
    DateTime Function()? clock,
    this.gamification = const GamificationService(),
  })  : recipes = List.unmodifiable(recipes),
        campusSpots = List.unmodifiable(campusSpots),
        achievements = List.unmodifiable(achievements),
        _logs = [...logs],
        _pantry = [...pantry],
        _plan = [...plan],
        _shopping = [...shopping],
        _discovered = {...discoveredRecipeIds},
        _xp = xp,
        _clock = clock ?? DateTime.now {
    _checkAchievements(awardXp: false);
  }

  factory NutriRepository.withSampleData({DateTime Function()? clock}) {
    final now = (clock ?? DateTime.now)();
    return NutriRepository(
      profile: MockData.profile,
      recipes: MockData.recipes,
      campusSpots: MockData.campusSpots,
      achievements: MockData.achievements,
      logs: MockData.logs(now),
      pantry: MockData.pantry,
      plan: MockData.plan(now),
      shopping: MockData.shopping,
      discoveredRecipeIds: MockData.discoveredRecipeIds,
      xp: MockData.startingXp,
      clock: clock,
    );
  }

  final UserProfile profile;
  final List<Recipe> recipes;
  final List<CampusSpot> campusSpots;
  final List<Achievement> achievements;
  final GamificationService gamification;

  final List<FoodLogEntry> _logs;
  final List<PantryItem> _pantry;
  final List<PlannedMeal> _plan;
  final List<ShoppingItem> _shopping;
  final Set<String> _discovered;
  final Set<AchievementId> _unlocked = {};
  final DateTime Function() _clock;
  int _xp;
  int _completedLists = 0;
  int _nextId = 1;

  DateTime now() => _clock();

  List<FoodLogEntry> get logs => List.unmodifiable(_logs);
  List<PantryItem> get pantry => List.unmodifiable(_pantry);
  List<PlannedMeal> get plan => List.unmodifiable(_plan);
  List<ShoppingItem> get shopping => List.unmodifiable(_shopping);

  int get xp => _xp;
  int get level => gamification.levelFor(_xp);
  double get levelProgress => gamification.progressInLevel(_xp);
  int get xpToNextLevel => gamification.xpToNextLevel(_xp);
  int get streak => gamification.streakFrom(_logs.map((e) => e.time), now());
  int get discoveredCount => _discovered.length;
  int get completedShoppingLists => _completedLists;

  bool isUnlocked(AchievementId id) => _unlocked.contains(id);

  int get plannedDaysThisWeek {
    final start = startOfWeek(now());
    final end = addDays(start, 7);
    return _plan
        .where((p) => !p.day.isBefore(start) && p.day.isBefore(end))
        .map((p) => p.day)
        .toSet()
        .length;
  }

  // ---- Food log ----

  void addLog({
    required String name,
    required MealType mealType,
    required DateTime time,
    required double cost,
    int calories = 0,
    int protein = 0,
  }) {
    _logs.add(FoodLogEntry(
      id: _newId('log'),
      name: name.trim(),
      mealType: mealType,
      time: time,
      cost: cost,
      calories: calories,
      protein: protein,
    ));
    _commit(XpReward.logMeal);
  }

  void updateLog(FoodLogEntry entry) {
    final i = _logs.indexWhere((e) => e.id == entry.id);
    if (i < 0) return;
    _logs[i] = entry;
    _commit();
  }

  FoodLogEntry? deleteLog(String id) {
    final i = _logs.indexWhere((e) => e.id == id);
    if (i < 0) return null;
    final removed = _logs.removeAt(i);
    _commit();
    return removed;
  }

  void restoreLog(FoodLogEntry entry) {
    _logs.add(entry);
    _commit();
  }

  // ---- Meal plan ----

  PlannedMeal? plannedMeal(DateTime day, MealType type) {
    for (final p in _plan) {
      if (isSameDay(p.day, day) && p.mealType == type) return p;
    }
    return null;
  }

  void planMeal(DateTime day, MealType type, Recipe recipe) {
    final entry = PlannedMeal(day: dateOnly(day), mealType: type, recipe: recipe);
    final i = _plan.indexWhere((p) => isSameDay(p.day, day) && p.mealType == type);
    if (i >= 0) {
      _plan[i] = entry;
      _commit();
    } else {
      _plan.add(entry);
      _commit(XpReward.planMeal);
    }
  }

  void unplanMeal(DateTime day, MealType type) {
    _plan.removeWhere((p) => isSameDay(p.day, day) && p.mealType == type);
    _commit();
  }

  // ---- Pantry ----

  bool hasInStock(String ingredient) {
    final key = _norm(ingredient);
    return _pantry.any((p) => p.name == key && p.quantity > 0);
  }

  void addPantryItem(String name, int quantity, String unit) {
    final key = _norm(name);
    final i = _pantry.indexWhere((p) => p.name == key);
    if (i >= 0) {
      _pantry[i] = _pantry[i].copyWith(quantity: _pantry[i].quantity + quantity);
    } else {
      _pantry.add(PantryItem(
        id: _newId('pantry'),
        name: key,
        quantity: quantity,
        unit: unit.trim().isEmpty ? 'pcs' : unit.trim(),
      ));
    }
    _commit(XpReward.pantryUpdate);
  }

  void setPantryQuantity(String id, int quantity) {
    final i = _pantry.indexWhere((p) => p.id == id);
    if (i < 0) return;
    _pantry[i] = _pantry[i].copyWith(quantity: max(0, quantity));
    _commit(XpReward.pantryUpdate);
  }

  void removePantryItem(String id) {
    _pantry.removeWhere((p) => p.id == id);
    _commit();
  }

  // ---- Shopping list ----

  /// Returns false if the name is blank or already on the list.
  bool addShoppingItem(String name, {ShoppingSource source = ShoppingSource.manual}) {
    final key = _norm(name);
    if (key.isEmpty) return false;
    if (_shopping.any((s) => !s.checked && s.name == key)) return false;
    _shopping.add(ShoppingItem(id: _newId('shop'), name: key, source: source));
    _commit();
    return true;
  }

  void toggleShoppingItem(String id) {
    final i = _shopping.indexWhere((s) => s.id == id);
    if (i < 0) return;
    final item = _shopping[i];
    _shopping[i] = item.copyWith(checked: !item.checked);
    _commit(item.checked ? -XpReward.shoppingItem : XpReward.shoppingItem);
  }

  void removeShoppingItem(String id) {
    _shopping.removeWhere((s) => s.id == id);
    _commit();
  }

  /// Moves checked items into the pantry and removes them from the list.
  /// Clearing a fully checked list counts as finishing it.
  int clearCheckedShopping() {
    final bought = _shopping.where((s) => s.checked).toList();
    if (bought.isEmpty) return 0;
    final finishedList = bought.length == _shopping.length;
    for (final item in bought) {
      _restock(item.name);
    }
    _shopping.removeWhere((s) => s.checked);
    if (finishedList) _completedLists++;
    _commit(finishedList ? XpReward.finishList : 0);
    return bought.length;
  }

  // ---- Discover ----

  void markDiscovered(String recipeId) {
    if (_discovered.add(recipeId)) _commit(XpReward.discoverMeal);
  }

  // ---- Internals ----

  void _restock(String name) {
    final i = _pantry.indexWhere((p) => p.name == name);
    if (i < 0) {
      _pantry.add(PantryItem(id: _newId('pantry'), name: name, quantity: 1, unit: 'pc', lowAt: 0));
      return;
    }
    final item = _pantry[i];
    if (item.quantity <= item.lowAt) {
      _pantry[i] = item.copyWith(quantity: item.lowAt + 2);
    }
  }

  void _commit([int xpDelta = 0]) {
    _xp = max(0, _xp + xpDelta);
    _checkAchievements();
    notifyListeners();
  }

  void _checkAchievements({bool awardXp = true}) {
    var changed = true;
    while (changed) {
      changed = false;
      for (final a in achievements) {
        if (_unlocked.contains(a.id) || !_meets(a.id)) continue;
        _unlocked.add(a.id);
        if (awardXp) _xp += a.xpReward;
        changed = true;
      }
    }
  }

  bool _meets(AchievementId id) => switch (id) {
        AchievementId.firstBite => _logs.isNotEmpty,
        AchievementId.onARoll => streak >= 3,
        AchievementId.weekPlanner => plannedDaysThisWeek == 7,
        AchievementId.stockedUp => _pantry.length >= 20,
        AchievementId.explorer => _discovered.length >= 5,
        AchievementId.checkedOut => _completedLists >= 1,
        AchievementId.levelFive => level >= 5,
      };

  String _newId(String prefix) => '$prefix-${_nextId++}';

  String _norm(String s) => s.trim().toLowerCase();
}
