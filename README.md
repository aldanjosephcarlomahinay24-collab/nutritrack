# NutriTrack

A food log, meal planner and pantry for college students on a budget. Built with Flutter and Dart.

## Screens

- **Dashboard**: greeting, today's spend against the budget, this week's spend, calories and today's meals
- **Food Log**: today's meals with delete, plus the Log a Meal form
- **Meal Plan**: planned meals for each weekday
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
  screens/       Dashboard, Food Log, Log a Meal, Meal Plan, Pantry, bottom navigation
  widgets/       shared cards and meal rows
test/
  widget_test.dart
```

## Team

- Aldan Joseph Carlo C. Mahinay: Meal model, MealStore, bottom navigation, Pantry
- Heizel Ann V. Manlangit: Food Log, Log a Meal form, Meal Plan
- RFD: Dashboard
