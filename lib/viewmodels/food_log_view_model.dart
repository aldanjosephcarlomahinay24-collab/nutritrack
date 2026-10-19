import '../core/formatters.dart';
import '../models/food_log_entry.dart';
import '../models/meal_type.dart';
import 'repository_view_model.dart';

class FoodLogViewModel extends RepositoryViewModel {
  FoodLogViewModel(super.repository) : _day = dateOnly(repository.now());

  DateTime _day;

  DateTime get selectedDay => _day;
  String get dayLabel => relativeDay(_day, repository.now());
  bool get canGoForward => _day.isBefore(dateOnly(repository.now()));

  List<FoodLogEntry> get entries => repository.logs
      .where((e) => isSameDay(e.time, _day))
      .toList()
    ..sort((a, b) => a.time.compareTo(b.time));

  double get totalCost => entries.fold(0, (sum, e) => sum + e.cost);
  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  int get totalProtein => entries.fold(0, (sum, e) => sum + e.protein);

  void previousDay() {
    _day = addDays(_day, -1);
    notifyListeners();
  }

  void nextDay() {
    if (!canGoForward) return;
    _day = addDays(_day, 1);
    notifyListeners();
  }

  /// Meal type guessed from the clock so logging needs fewer taps.
  MealType suggestedTypeFor(DateTime time) {
    if (time.hour < 10) return MealType.breakfast;
    if (time.hour < 14) return MealType.lunch;
    if (time.hour < 17) return MealType.snack;
    return MealType.dinner;
  }

  /// Default time for a new entry: now if viewing today, noon otherwise.
  DateTime defaultTime() {
    final now = repository.now();
    if (isSameDay(_day, now)) return now;
    return _day.add(const Duration(hours: 12));
  }

  void add({
    required String name,
    required MealType mealType,
    required DateTime time,
    required double cost,
    int calories = 0,
    int protein = 0,
  }) {
    repository.addLog(
      name: name,
      mealType: mealType,
      time: time,
      cost: cost,
      calories: calories,
      protein: protein,
    );
  }

  void update(FoodLogEntry entry) => repository.updateLog(entry);

  FoodLogEntry? delete(String id) => repository.deleteLog(id);

  void undoDelete(FoodLogEntry entry) => repository.restoreLog(entry);

  static String? validateName(String? value) =>
      (value == null || value.trim().isEmpty) ? 'What did you eat?' : null;

  static String? validateCost(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final cost = double.tryParse(value.trim());
    if (cost == null || cost < 0) return 'Enter an amount like 75';
    return null;
  }
}
