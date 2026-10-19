import '../core/formatters.dart';

/// XP given for each activity.
class XpReward {
  XpReward._();

  static const logMeal = 10;
  static const planMeal = 5;
  static const pantryUpdate = 2;
  static const shoppingItem = 3;
  static const finishList = 15;
  static const discoverMeal = 8;
}

/// Level and streak math. Pure functions, no state.
class GamificationService {
  const GamificationService({this.xpPerLevel = 100});

  final int xpPerLevel;

  int levelFor(int xp) => xp ~/ xpPerLevel + 1;

  double progressInLevel(int xp) => (xp % xpPerLevel) / xpPerLevel;

  int xpToNextLevel(int xp) => xpPerLevel - xp % xpPerLevel;

  /// Consecutive days with activity, ending today. A streak is still alive if
  /// the last activity was yesterday.
  int streakFrom(Iterable<DateTime> activity, DateTime now) {
    final days = activity.map(dateOnly).toSet();
    var cursor = dateOnly(now);
    if (!days.contains(cursor)) cursor = addDays(cursor, -1);
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = addDays(cursor, -1);
    }
    return streak;
  }
}
