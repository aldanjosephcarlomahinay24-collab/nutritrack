import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutritrack/data/meal_store.dart';
import 'package:nutritrack/main.dart';
import 'package:nutritrack/models/meal.dart';

void main() {
  test('totals add up today\'s meals', () {
    final store = MealStore();
    final now = DateTime.now();
    store.addMeal(
      name: 'Adobo',
      type: MealType.lunch,
      eatenAt: now,
      cost: 95,
      calories: 620,
      protein: 34,
    );
    store.addMeal(
      name: 'Banana cue',
      type: MealType.snack,
      eatenAt: now,
      cost: 45,
      calories: 240,
      protein: 1.5,
    );
    expect(store.today.cost, 140);
    expect(store.today.calories, 860);
    expect(store.today.protein, 35.5);
  });

  test('editing and deleting a meal updates the totals', () {
    final store = MealStore();
    store.addMeal(
      name: 'Adobo',
      type: MealType.lunch,
      eatenAt: DateTime.now(),
      cost: 95,
    );
    final meal = store.todayMeals.first;
    store.updateMeal(meal.copyWith(cost: 80));
    expect(store.todaySpend, 80);
    store.deleteMeal(meal.id);
    expect(store.todaySpend, 0);
  });

  test('streak counts days in a row with a logged meal', () {
    final store = MealStore();
    final now = DateTime.now();
    for (var d = 0; d < 3; d++) {
      store.addMeal(
        name: 'Meal',
        type: MealType.lunch,
        eatenAt: now.subtract(Duration(days: d)),
        cost: 50,
      );
    }
    expect(store.currentStreak, 3);
    expect(store.bestStreak, 3);
  });

  testWidgets('bottom bar switches to the Fuel tab', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      NutriTrackApp(store: MealStore()..loadSampleData()),
    );
    await tester.tap(find.text('FUEL'));
    await tester.pumpAndSettle();
    expect(find.text('Fuel'), findsOneWidget);
    expect(find.text('14-DAY HISTORY'), findsOneWidget);
  });
}
