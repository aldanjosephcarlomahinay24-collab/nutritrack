import '../models/achievement.dart';
import 'repository_view_model.dart';

class ProgressViewModel extends RepositoryViewModel {
  ProgressViewModel(super.repository);

  String get name => repository.profile.name;
  String get campus => repository.profile.campus;
  int get xp => repository.xp;
  int get level => repository.level;
  double get levelProgress => repository.levelProgress;
  int get xpToNextLevel => repository.xpToNextLevel;
  int get streak => repository.streak;

  List<Achievement> get achievements => repository.achievements;
  bool isUnlocked(Achievement a) => repository.isUnlocked(a.id);
  int get unlockedCount => achievements.where(isUnlocked).length;

  int get mealsLogged => repository.logs.length;
  int get mealsPlanned => repository.plan.length;
  int get pantryItems => repository.pantry.length;
  int get mealsDiscovered => repository.discoveredCount;
  int get listsCompleted => repository.completedShoppingLists;
}
