import '../models/campus_spot.dart';
import '../models/meal_type.dart';
import 'repository_view_model.dart';

enum CampusSort { cheapest, priciest, nearest }

class CampusEatsViewModel extends RepositoryViewModel {
  CampusEatsViewModel(super.repository);

  static const budgets = <double?>[null, 50, 80, 120];

  CampusSort _sort = CampusSort.cheapest;
  MealType? _mealType;
  double? _maxBudget;

  CampusSort get sort => _sort;
  MealType? get mealType => _mealType;
  double? get maxBudget => _maxBudget;

  void setSort(CampusSort sort) {
    _sort = sort;
    notifyListeners();
  }

  void setMealType(MealType? type) {
    _mealType = type;
    notifyListeners();
  }

  void setMaxBudget(double? budget) {
    _maxBudget = budget;
    notifyListeners();
  }

  List<CampusSpot> get spots {
    final budget = _maxBudget;
    final list = repository.campusSpots
        .where((s) => _mealType == null || s.mealType == _mealType)
        .where((s) => budget == null || s.price <= budget)
        .toList();
    list.sort((a, b) => switch (_sort) {
          CampusSort.cheapest => a.price.compareTo(b.price),
          CampusSort.priciest => b.price.compareTo(a.price),
          CampusSort.nearest => a.walkMinutes.compareTo(b.walkMinutes),
        });
    return list;
  }
}
