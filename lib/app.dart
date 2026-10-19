import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'data/nutri_repository.dart';
import 'viewmodels/campus_eats_view_model.dart';
import 'viewmodels/dashboard_view_model.dart';
import 'viewmodels/food_log_view_model.dart';
import 'viewmodels/meal_finder_view_model.dart';
import 'viewmodels/meal_plan_view_model.dart';
import 'viewmodels/pantry_view_model.dart';
import 'viewmodels/progress_view_model.dart';
import 'viewmodels/shell_view_model.dart';
import 'viewmodels/shopping_list_view_model.dart';
import 'views/campus/campus_eats_view.dart';
import 'views/discover/meal_finder_view.dart';
import 'views/progress/progress_view.dart';
import 'views/shell/main_shell.dart';
import 'views/shopping/shopping_list_view.dart';

/// Wires the layers together: one repository (Model), one view model per
/// feature (ViewModel), and the screens (View) reached through the shell and
/// named routes.
class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key, required this.repository});

  final NutriRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: repository),
        ChangeNotifierProvider(create: (_) => ShellViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(repository)),
        ChangeNotifierProvider(create: (_) => FoodLogViewModel(repository)),
        ChangeNotifierProvider(create: (_) => MealPlanViewModel(repository)),
        ChangeNotifierProvider(create: (_) => PantryViewModel(repository)),
        ChangeNotifierProvider(create: (_) => MealFinderViewModel(repository)),
        ChangeNotifierProvider(create: (_) => ShoppingListViewModel(repository)),
        ChangeNotifierProvider(create: (_) => CampusEatsViewModel(repository)),
        ChangeNotifierProvider(create: (_) => ProgressViewModel(repository)),
      ],
      child: MaterialApp(
        title: 'NutriTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        initialRoute: AppRoutes.shell,
        routes: {
          AppRoutes.shell: (_) => const MainShell(),
          AppRoutes.mealFinder: (_) => const MealFinderView(),
          AppRoutes.shoppingList: (_) => const ShoppingListView(),
          AppRoutes.campusEats: (_) => const CampusEatsView(),
          AppRoutes.progress: (_) => const ProgressView(),
        },
      ),
    );
  }
}
