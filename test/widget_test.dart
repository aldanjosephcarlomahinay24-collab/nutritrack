import 'package:flutter_test/flutter_test.dart';
import 'package:nutritrack/app.dart';
import 'package:nutritrack/data/nutri_repository.dart';
import 'package:nutritrack/models/meal_type.dart';
import 'package:nutritrack/services/gamification_service.dart';
import 'package:nutritrack/viewmodels/shopping_list_view_model.dart';

void main() {
  // Fixed clock so greetings, streaks and "today" are predictable.
  DateTime clock() => DateTime(2026, 10, 20, 18, 30);

  testWidgets('dashboard greets the user and bottom nav switches tabs',
      (tester) async {
    await tester.pumpWidget(
        NutriTrackApp(repository: NutriRepository.withSampleData(clock: clock)));

    expect(find.text('Good evening, Aldan'), findsOneWidget);

    await tester.tap(find.text('Pantry'));
    await tester.pumpAndSettle();
    expect(find.text('Add item'), findsOneWidget);

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Campus Eats'));
    await tester.pumpAndSettle();
    expect(find.text('15 spots near campus'), findsOneWidget);
  });

  test('logging a meal gives XP', () {
    final repo = NutriRepository.withSampleData(clock: clock);
    final before = repo.xp;
    repo.addLog(
        name: 'Siomai rice', mealType: MealType.dinner, time: clock(), cost: 55);
    expect(repo.xp, greaterThanOrEqualTo(before + XpReward.logMeal));
    expect(repo.logs.where((e) => e.name == 'Siomai rice'), hasLength(1));
  });

  test('streak counts consecutive days ending today', () {
    const game = GamificationService();
    final now = clock();
    final days = [
      now,
      now.subtract(const Duration(days: 1)),
      now.subtract(const Duration(days: 2)),
    ];
    expect(game.streakFrom(days, now), 3);
    expect(game.streakFrom([now.subtract(const Duration(days: 3))], now), 0);
  });

  test('grocery list = planned ingredients minus pantry', () {
    final repo = NutriRepository.withSampleData(clock: clock);
    ShoppingListViewModel(repo).buildFromPlanAndPantry();
    final names = repo.shopping.map((s) => s.name).toSet();
    expect(names, contains('malunggay')); // tinola tonight, not in pantry
    expect(names, isNot(contains('egg'))); // in stock
  });
}
