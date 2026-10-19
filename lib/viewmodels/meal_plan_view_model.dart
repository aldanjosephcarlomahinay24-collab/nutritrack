import '../core/formatters.dart';
import '../models/meal_type.dart';
import '../models/planned_meal.dart';
import '../models/recipe.dart';
import 'repository_view_model.dart';

class MealPlanViewModel extends RepositoryViewModel {
  MealPlanViewModel(super.repository)
      : _weekStart = startOfWeek(repository.now()),
        _selected = dateOnly(repository.now());

  DateTime _weekStart;
  DateTime _selected;

  DateTime get selectedDay => _selected;
  DateTime get today => dateOnly(repository.now());

  List<DateTime> get days => List.generate(7, (i) => addDays(_weekStart, i));

  String get weekLabel =>
      '${shortDate(_weekStart)} - ${shortDate(addDays(_weekStart, 6))}';

  String get selectedDayLabel => relativeDay(_selected, repository.now());

  void selectDay(DateTime day) {
    _selected = dateOnly(day);
    notifyListeners();
  }

  void changeWeek(int offset) {
    _weekStart = addDays(_weekStart, 7 * offset);
    _selected = _weekStart;
    notifyListeners();
  }

  PlannedMeal? mealFor(DateTime day, MealType type) =>
      repository.plannedMeal(day, type);

  bool hasPlan(DateTime day) =>
      MealType.values.any((t) => mealFor(day, t) != null);

  int caloriesFor(DateTime day) => MealType.values
      .map((t) => mealFor(day, t)?.recipe.calories ?? 0)
      .fold(0, (a, b) => a + b);

  int get plannedThisWeek => days
      .expand((d) => MealType.values.map((t) => mealFor(d, t)))
      .whereType<PlannedMeal>()
      .length;

  int get slotsThisWeek => 7 * MealType.values.length;

  /// Recipes for the slot's meal type first, then the rest.
  List<Recipe> recipesFor(MealType type) {
    final all = [...repository.recipes];
    all.sort((a, b) {
      final aMatch = a.mealType == type ? 0 : 1;
      final bMatch = b.mealType == type ? 0 : 1;
      return aMatch != bMatch ? aMatch - bMatch : a.name.compareTo(b.name);
    });
    return all;
  }

  void assign(MealType type, Recipe recipe) =>
      repository.planMeal(_selected, type, recipe);

  void clear(MealType type) => repository.unplanMeal(_selected, type);
}
