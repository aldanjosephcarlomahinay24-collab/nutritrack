import '../core/formatters.dart';
import '../models/food_log_entry.dart';
import '../models/pantry_item.dart';
import '../models/planned_meal.dart';
import 'repository_view_model.dart';

class DashboardViewModel extends RepositoryViewModel {
  DashboardViewModel(super.repository);

  DateTime get _now => repository.now();

  String get greeting => '${greetingFor(_now)}, ${repository.profile.name}';
  String get todayLabel => '${shortWeekday(_now)}, ${shortDate(_now)}';
  String get initials => repository.profile.name.substring(0, 1).toUpperCase();

  List<FoodLogEntry> get todaysMeals => repository.logs
      .where((e) => isSameDay(e.time, _now))
      .toList()
    ..sort((a, b) => a.time.compareTo(b.time));

  double get todaySpend => todaysMeals.fold(0, (sum, e) => sum + e.cost);
  int get todayCalories => todaysMeals.fold(0, (sum, e) => sum + e.calories);
  int get todayProtein => todaysMeals.fold(0, (sum, e) => sum + e.protein);

  double get weekSpend {
    final start = startOfWeek(_now);
    return repository.logs
        .where((e) => !e.time.isBefore(start))
        .fold(0, (sum, e) => sum + e.cost);
  }

  List<PlannedMeal> get plannedToday => repository.plan
      .where((p) => isSameDay(p.day, _now))
      .toList()
    ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));

  int get lowStockCount =>
      repository.pantry.where((p) => p.status != StockStatus.inStock).length;

  int get level => repository.level;
  int get xp => repository.xp;
  double get levelProgress => repository.levelProgress;
  int get xpToNextLevel => repository.xpToNextLevel;
  int get streak => repository.streak;
}
