# NutriTrack

A food log, meal planner and pantry for college students on a budget. Built with Flutter and Dart.

## Screens

- **Today**: greeting, logging streak with your best, meals and spend tiles, and goals that tick themselves
- **Fuel**: day switcher, calorie ring with goal and what's left, protein/carbs/fat chips, 14-day history chart, meals grouped by type with edit and delete
- **Plan**: planned meals for each weekday
- **Pantry**: add and remove ingredients

## Run it in Visual Studio Code

1. Install the **Flutter** and **Dart** extensions.
2. Open this folder in VS Code.
3. Run `flutter pub get` in the terminal.
4. Pick a device in the bottom-right corner (an Android emulator, Chrome or Windows), then press **F5**.

## Run the tests

```
flutter test
```

## Project structure

```
lib/
  main.dart
  app_theme.dart
  models/        Meal, PantryItem
  data/          MealStore
  screens/       Today, Fuel, Log a Meal, Plan, Pantry, bottom navigation
  widgets/       cards, charts, meal rows, bottom bar
test/
  widget_test.dart
```

## Team

- Aldan Joseph Carlo C. Mahinay: MealStore (totals, history, streaks), bottom bar and navigation, Pantry
- Heizel Ann V. Manlangit: Fuel screen, log and edit meal form, Meal Plan
- Rein: Today screen, streak card, today's goals
