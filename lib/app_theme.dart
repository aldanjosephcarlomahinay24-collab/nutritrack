import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF111111);
  static const muted = Color(0xFF6B6B6B);
  static const background = Color(0xFFFFFFFF);
  static const blue = Color(0xFF2563EB);
  static const blueSoft = Color(0xFFDDE6FF);
  static const blueMid = Color(0xFFBBD7FF);
  static const blueLight = Color(0xFF90C2FF);
  static const pink = Color(0xFFFF90E8);
  static const track = Color(0xFFDADADA);
}

const popBorder = BorderSide(color: AppColors.ink, width: 2.5);
const popShadow = [BoxShadow(color: AppColors.ink, offset: Offset(4, 6))];
const monoFont = 'monospace';

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      primary: AppColors.ink,
      secondaryContainer: AppColors.blue,
      onSecondaryContainer: Colors.white,
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
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: AppColors.blue,
      checkmarkColor: Colors.white,
      side: popBorder,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      secondaryLabelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        backgroundColor: Colors.white,
        side: popBorder,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.blue,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: popBorder,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: popBorder,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: popBorder,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.blue, width: 3),
      ),
    ),
  );
}
