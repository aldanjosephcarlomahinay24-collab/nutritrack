import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF000000);
  static const muted = Color(0xFF5C5C5C);
  static const background = Color(0xFFFFFFFF);
  static const pink = Color(0xFFFF90E8);
  static const blue = Color(0xFF90A8ED);
}

const popBorder = BorderSide(color: AppColors.ink, width: 2);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      primary: AppColors.ink,
      secondaryContainer: AppColors.pink,
      onSecondaryContainer: AppColors.ink,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      shape: Border(bottom: popBorder),
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: AppColors.pink,
      checkmarkColor: AppColors.ink,
      side: popBorder,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      secondaryLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        backgroundColor: Colors.white,
        side: popBorder,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.pink,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: popBorder,
      ),
      iconTheme: const WidgetStatePropertyAll(
        IconThemeData(color: AppColors.ink),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w900
              : FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.blue,
      contentTextStyle: const TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: popBorder,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFF9A9A9A)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: popBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: popBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.pink, width: 3),
      ),
    ),
  );
}
