import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutritrack/data/meal_store.dart';
import 'package:nutritrack/main.dart';
import 'package:nutritrack/models/meal.dart';

void main() {
  test('totals add up today\'s meal costs', () {
    final store = MealStore();
    final now = DateTime.now();
    store.addMeal(name: 'Adobo', type: MealType.lunch, eatenAt: now, cost: 95);
    store.addMeal(
      name: 'Banana cue',
      type: MealType.snack,
      eatenAt: now,
      cost: 45,
    );
    expect(store.todaySpend, 140);
    expect(store.todayMeals.length, 2);
  });

  test('deleting a meal updates the total', () {
    final store = MealStore();
    store.addMeal(
      name: 'Adobo',
      type: MealType.lunch,
      eatenAt: DateTime.now(),
      cost: 95,
    );
    store.deleteMeal(store.todayMeals.first.id);
    expect(store.todaySpend, 0);
  });

  testWidgets('bottom nav switches to the Food Log', (tester) async {
    await tester.pumpWidget(
      NutriTrackApp(store: MealStore()..loadSampleData()),
    );
    expect(find.text('NUTRITRACK'), findsOneWidget);
    await tester.tap(find.text('Food Log'));
    await tester.pumpAndSettle();
    expect(find.text('FOOD LOG'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
