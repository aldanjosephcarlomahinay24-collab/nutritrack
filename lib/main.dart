import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/meal_store.dart';
import 'screens/main_navigation.dart';

void main() {
  final store = MealStore()..loadSampleData();
  runApp(NutriTrackApp(store: store));
}

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key, required this.store});

  final MealStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: MainNavigation(store: store),
    );
  }
}
