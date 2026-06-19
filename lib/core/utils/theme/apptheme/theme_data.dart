import 'package:flutter/material.dart';

import '../appcolor/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'inter',
    primaryColor: AppColors.primary,
    // buttonTextColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.success,
      surface: AppColors.lightCard,
      error: AppColors.expense,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightText,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightCard,
      shadowColor: AppColors.shadowSoft,
      surfaceTintColor: AppColors.transparent,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderMuted,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shadowColor: AppColors.successGlow,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      hintStyle: TextStyle(color: AppColors.inputHint),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.expense),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.lightText),
      headlineMedium: TextStyle(color: AppColors.lightText),
      headlineSmall: TextStyle(color: AppColors.lightText),
      titleLarge: TextStyle(color: AppColors.lightText),
      titleMedium: TextStyle(color: AppColors.lightText),
      titleSmall: TextStyle(color: AppColors.lightSubtitle),
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightSubtitle),
      bodySmall: TextStyle(color: AppColors.mutedText),
      labelLarge: TextStyle(color: AppColors.lightText),
      labelMedium: TextStyle(color: AppColors.lightSubtitle),
      labelSmall: TextStyle(color: AppColors.disabledText),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'inter',
    primaryColor: AppColors.darkBar,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkBar,
      secondary: AppColors.primary,
      surface: AppColors.darkCard,
      error: AppColors.expense,
      onPrimary: AppColors.black,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkCard,
      shadowColor: AppColors.darkCardShadow,
      surfaceTintColor: AppColors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkCard,
      thickness: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkBar,
      foregroundColor: AppColors.black,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.darkBar,
      linearTrackColor: AppColors.darkCard,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBar,
        foregroundColor: AppColors.black,
        shadowColor: AppColors.darkCardShadow,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      hintStyle: TextStyle(color: AppColors.darkSubtitle),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkCard),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkBar),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.expense),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.darkText),
      headlineMedium: TextStyle(color: AppColors.darkText),
      headlineSmall: TextStyle(color: AppColors.darkText),
      titleLarge: TextStyle(color: AppColors.darkText),
      titleMedium: TextStyle(color: AppColors.darkText),
      titleSmall: TextStyle(color: AppColors.darkSubtitle),
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkSubtitle),
      bodySmall: TextStyle(color: AppColors.darkSubtitle),
      labelLarge: TextStyle(color: AppColors.darkText),
      labelMedium: TextStyle(color: AppColors.darkSubtitle),
      labelSmall: TextStyle(color: AppColors.darkSubtitle),
    ),
  );
}
