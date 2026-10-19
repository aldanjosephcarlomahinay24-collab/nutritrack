import '../core/formatters.dart';
import '../models/achievement.dart';
import '../models/campus_spot.dart';
import '../models/food_log_entry.dart';
import '../models/meal_type.dart';
import '../models/pantry_item.dart';
import '../models/planned_meal.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../models/user_profile.dart';

/// Fictional sample data so every screen has something to show before a real
/// database exists. No real student records.
class MockData {
  MockData._();

  static const profile = UserProfile(name: 'Aldan');

  static const recipes = <Recipe>[
    Recipe(id: 'r1', name: 'Tortang Talong', mealType: MealType.lunch, ingredients: ['eggplant', 'egg', 'garlic', 'onion'], calories: 220, protein: 11, minutes: 20),
    Recipe(id: 'r2', name: 'Garlic Rice and Egg', mealType: MealType.breakfast, ingredients: ['rice', 'egg', 'garlic'], calories: 420, protein: 14, minutes: 10),
    Recipe(id: 'r3', name: 'Chicken Adobo', mealType: MealType.dinner, ingredients: ['chicken', 'soy sauce', 'vinegar', 'garlic', 'rice'], calories: 610, protein: 38, minutes: 45),
    Recipe(id: 'r4', name: 'Chicken Tinola', mealType: MealType.dinner, ingredients: ['chicken', 'ginger', 'malunggay', 'onion', 'rice'], calories: 480, protein: 35, minutes: 40),
    Recipe(id: 'r5', name: 'Pork Sinigang', mealType: MealType.dinner, ingredients: ['pork', 'sinigang mix', 'tomato', 'onion', 'rice'], calories: 560, protein: 30, minutes: 50),
    Recipe(id: 'r6', name: 'Pancit Canton with Egg', mealType: MealType.snack, ingredients: ['pancit canton', 'egg', 'onion'], calories: 470, protein: 15, minutes: 10),
    Recipe(id: 'r7', name: 'Ginisang Monggo', mealType: MealType.lunch, ingredients: ['monggo', 'garlic', 'onion', 'tomato', 'malunggay', 'rice'], calories: 450, protein: 22, minutes: 45),
    Recipe(id: 'r8', name: 'Tuna Sandwich', mealType: MealType.breakfast, ingredients: ['bread', 'canned tuna', 'mayonnaise', 'onion'], calories: 380, protein: 22, minutes: 5),
    Recipe(id: 'r9', name: 'Oatmeal with Banana', mealType: MealType.breakfast, ingredients: ['oats', 'milk', 'banana'], calories: 310, protein: 10, minutes: 7),
    Recipe(id: 'r10', name: 'Ginisang Sardinas', mealType: MealType.lunch, ingredients: ['sardines', 'tomato', 'onion', 'garlic', 'rice'], calories: 430, protein: 21, minutes: 15),
    Recipe(id: 'r11', name: 'Corned Beef Hash', mealType: MealType.breakfast, ingredients: ['corned beef', 'potato', 'onion', 'garlic'], calories: 440, protein: 20, minutes: 20),
    Recipe(id: 'r12', name: 'Ampalaya with Egg', mealType: MealType.lunch, ingredients: ['ampalaya', 'egg', 'tomato', 'onion', 'garlic'], calories: 210, protein: 12, minutes: 15),
    Recipe(id: 'r13', name: 'Tuna Pasta', mealType: MealType.dinner, ingredients: ['pasta', 'canned tuna', 'garlic', 'tomato'], calories: 520, protein: 28, minutes: 20),
    Recipe(id: 'r14', name: 'Peanut Butter Banana Toast', mealType: MealType.snack, ingredients: ['bread', 'peanut butter', 'banana'], calories: 330, protein: 10, minutes: 3),
    Recipe(id: 'r15', name: 'Banana Pancakes', mealType: MealType.breakfast, ingredients: ['flour', 'egg', 'banana', 'milk'], calories: 400, protein: 12, minutes: 15),
    Recipe(id: 'r16', name: 'Arroz Caldo', mealType: MealType.dinner, ingredients: ['rice', 'chicken', 'ginger', 'garlic', 'onion'], calories: 380, protein: 22, minutes: 40),
    Recipe(id: 'r17', name: 'Tomato Egg Stir-fry', mealType: MealType.lunch, ingredients: ['egg', 'tomato', 'onion', 'rice'], calories: 360, protein: 15, minutes: 10),
    Recipe(id: 'r18', name: 'Egg Fried Rice', mealType: MealType.breakfast, ingredients: ['rice', 'egg', 'garlic', 'soy sauce', 'onion'], calories: 450, protein: 13, minutes: 10),
    Recipe(id: 'r19', name: 'Yogurt Banana Cup', mealType: MealType.snack, ingredients: ['yogurt', 'banana'], calories: 180, protein: 7, minutes: 2),
    Recipe(id: 'r20', name: 'Lugaw with Egg', mealType: MealType.breakfast, ingredients: ['rice', 'ginger', 'garlic', 'egg'], calories: 290, protein: 10, minutes: 30),
  ];

  static const pantry = <PantryItem>[
    PantryItem(id: 'p1', name: 'rice', quantity: 2, unit: 'kg', lowAt: 0),
    PantryItem(id: 'p2', name: 'egg', quantity: 6, unit: 'pcs', lowAt: 2),
    PantryItem(id: 'p3', name: 'garlic', quantity: 1, unit: 'head'),
    PantryItem(id: 'p4', name: 'onion', quantity: 3, unit: 'pcs'),
    PantryItem(id: 'p5', name: 'tomato', quantity: 2, unit: 'pcs'),
    PantryItem(id: 'p6', name: 'eggplant', quantity: 2, unit: 'pcs'),
    PantryItem(id: 'p7', name: 'soy sauce', quantity: 1, unit: 'bottle', lowAt: 0),
    PantryItem(id: 'p8', name: 'vinegar', quantity: 1, unit: 'bottle', lowAt: 0),
    PantryItem(id: 'p9', name: 'canned tuna', quantity: 1, unit: 'can'),
    PantryItem(id: 'p10', name: 'bread', quantity: 0, unit: 'pack'),
    PantryItem(id: 'p11', name: 'oats', quantity: 1, unit: 'pack', lowAt: 0),
    PantryItem(id: 'p12', name: 'banana', quantity: 4, unit: 'pcs'),
    PantryItem(id: 'p13', name: 'milk', quantity: 0, unit: 'box'),
    PantryItem(id: 'p14', name: 'sardines', quantity: 2, unit: 'cans'),
    PantryItem(id: 'p15', name: 'pancit canton', quantity: 3, unit: 'packs'),
  ];

  /// Hand-entered list of 15 spots near campus. Names are placeholders.
  static const campusSpots = <CampusSpot>[
    CampusSpot(name: "Ate Lorna's Carinderia", dish: 'Rice + 2 viands', price: 75, mealType: MealType.lunch, walkMinutes: 3, hours: '7AM-7PM'),
    CampusSpot(name: 'Corner Silog Stall', dish: 'Tapsilog', price: 85, mealType: MealType.breakfast, walkMinutes: 4, hours: '6AM-2PM'),
    CampusSpot(name: 'Siomai Cart by the Gate', dish: 'Siomai rice (4 pcs)', price: 55, mealType: MealType.snack, walkMinutes: 2, hours: '9AM-6PM'),
    CampusSpot(name: 'Lugawan sa Kanto', dish: 'Lugaw with egg', price: 40, mealType: MealType.breakfast, walkMinutes: 5, hours: '5AM-11AM'),
    CampusSpot(name: 'Puso and Grill', dish: 'Pork BBQ + 2 puso', price: 70, mealType: MealType.dinner, walkMinutes: 6, hours: '4PM-11PM'),
    CampusSpot(name: 'School Canteen', dish: 'Chicken adobo meal', price: 65, mealType: MealType.lunch, walkMinutes: 1, hours: '7AM-5PM'),
    CampusSpot(name: 'Ngohiong Corner', dish: 'Ngohiong + rice', price: 50, mealType: MealType.snack, walkMinutes: 4, hours: '10AM-8PM'),
    CampusSpot(name: 'Pandesal Bakery', dish: 'Pandesal (10 pcs)', price: 30, mealType: MealType.breakfast, walkMinutes: 3, hours: '5AM-9PM'),
    CampusSpot(name: 'Night Market BBQ', dish: 'Chicken BBQ set', price: 95, mealType: MealType.dinner, walkMinutes: 10, hours: '5PM-12AM'),
    CampusSpot(name: 'Fishball Cart', dish: 'Fishball cup', price: 20, mealType: MealType.snack, walkMinutes: 2, hours: '2PM-8PM'),
    CampusSpot(name: "Tita's Pancitan", dish: 'Pancit bihon plate', price: 60, mealType: MealType.lunch, walkMinutes: 5, hours: '9AM-6PM'),
    CampusSpot(name: 'Healthy Bowl Kiosk', dish: 'Chicken rice bowl', price: 120, mealType: MealType.lunch, walkMinutes: 7, hours: '10AM-8PM'),
    CampusSpot(name: 'Kape and Toast', dish: 'Coffee + toast', price: 65, mealType: MealType.breakfast, walkMinutes: 4, hours: '6AM-6PM'),
    CampusSpot(name: 'Halo-Halo Hut', dish: 'Halo-halo', price: 70, mealType: MealType.snack, walkMinutes: 6, hours: '11AM-9PM'),
    CampusSpot(name: 'Lechon Manok Stand', dish: 'Quarter chicken + rice', price: 110, mealType: MealType.dinner, walkMinutes: 8, hours: '10AM-9PM'),
  ];

  static const achievements = <Achievement>[
    Achievement(id: AchievementId.firstBite, title: 'First Bite', description: 'Log your first meal.', xpReward: 10),
    Achievement(id: AchievementId.onARoll, title: 'On a Roll', description: 'Log meals 3 days in a row.', xpReward: 25),
    Achievement(id: AchievementId.weekPlanner, title: 'Week Planner', description: 'Plan at least one meal for all 7 days of a week.', xpReward: 40),
    Achievement(id: AchievementId.stockedUp, title: 'Stocked Up', description: 'Track 20 pantry items.', xpReward: 20),
    Achievement(id: AchievementId.explorer, title: 'Explorer', description: 'Discover 5 meals in What Can I Make?', xpReward: 20),
    Achievement(id: AchievementId.checkedOut, title: 'Checked Out', description: 'Finish a whole shopping list.', xpReward: 20),
    Achievement(id: AchievementId.levelFive, title: 'Level 5', description: 'Reach level 5.', xpReward: 50),
  ];

  static const discoveredRecipeIds = {'r2', 'r6'};

  static const startingXp = 180;

  static List<FoodLogEntry> logs(DateTime now) {
    final today = dateOnly(now);
    DateTime at(int daysAgo, int hour, [int minute = 0]) =>
        addDays(today, -daysAgo).add(Duration(hours: hour, minutes: minute));
    return [
      FoodLogEntry(id: 'l1', name: 'Lugaw with egg', mealType: MealType.breakfast, time: at(2, 7, 15), cost: 40, calories: 290, protein: 10),
      FoodLogEntry(id: 'l2', name: 'Chicken adobo meal', mealType: MealType.lunch, time: at(2, 12, 10), cost: 65, calories: 610, protein: 38),
      FoodLogEntry(id: 'l3', name: 'Garlic rice and egg', mealType: MealType.breakfast, time: at(1, 7), cost: 25, calories: 420, protein: 14),
      FoodLogEntry(id: 'l4', name: 'Rice + 2 viands', mealType: MealType.lunch, time: at(1, 12, 30), cost: 75, calories: 650, protein: 30),
      FoodLogEntry(id: 'l5', name: 'Pancit canton with egg', mealType: MealType.dinner, time: at(1, 19), cost: 30, calories: 470, protein: 15),
      FoodLogEntry(id: 'l6', name: 'Oatmeal with banana', mealType: MealType.breakfast, time: at(0, 7, 30), cost: 20, calories: 310, protein: 10),
    ];
  }

  static List<PlannedMeal> plan(DateTime now) {
    final today = dateOnly(now);
    Recipe r(String id) => recipes.firstWhere((recipe) => recipe.id == id);
    return [
      PlannedMeal(day: today, mealType: MealType.lunch, recipe: r('r1')),
      PlannedMeal(day: today, mealType: MealType.dinner, recipe: r('r4')),
      PlannedMeal(day: addDays(today, 1), mealType: MealType.breakfast, recipe: r('r9')),
      PlannedMeal(day: addDays(today, 1), mealType: MealType.dinner, recipe: r('r3')),
      PlannedMeal(day: addDays(today, 2), mealType: MealType.lunch, recipe: r('r7')),
    ];
  }

  static const shopping = <ShoppingItem>[
    ShoppingItem(id: 's1', name: 'milk', source: ShoppingSource.pantry),
    ShoppingItem(id: 's2', name: 'bread', source: ShoppingSource.pantry),
    ShoppingItem(id: 's3', name: 'chicken', source: ShoppingSource.plan),
  ];
}
