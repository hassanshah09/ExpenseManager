import 'package:flutter/material.dart';

abstract final class OwlColors {
  static const navy = Color(0xFF0D1B34);
  static const navyLight = Color(0xFF182B4A);
  static const gold = Color(0xFFE4B63F);
  static const canvas = Color(0xFFF6F7F4);
  static const ink = Color(0xFF182238);
  static const muted = Color(0xFF8992A1);
  static const green = Color(0xFF2DA779);
  static const red = Color(0xFFE26861);
  static const blue = Color(0xFF5693D0);
  static const purple = Color(0xFF9272CC);
  static const teal = Color(0xFF42AFA4);
  static const border = Color(0xFFE8EAE7);
}

ThemeData buildOwlTheme({bool dark = false}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: OwlColors.navy,
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: OwlColors.navy,
    secondary: OwlColors.gold,
    surface: dark ? const Color(0xFF172338) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF0C1524) : OwlColors.canvas,
    fontFamily: 'Roboto',
    textTheme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light)
        .textTheme
        .apply(
          bodyColor: dark ? Colors.white : OwlColors.ink,
          displayColor: dark ? Colors.white : OwlColors.ink,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: OwlColors.canvas,
      foregroundColor: OwlColors.ink,
      centerTitle: false,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF172338) : Colors.white,
      hintStyle: const TextStyle(color: OwlColors.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: OwlColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: OwlColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: OwlColors.gold, width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF172338) : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: dark ? Colors.white10 : OwlColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
  );
}
