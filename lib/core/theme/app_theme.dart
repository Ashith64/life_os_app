import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);
  
  // Data visualization colors
  static const Color accentNeonBlue = Color(0xFF00F0FF);
  static const Color accentElectricGreen = Color(0xFF00FF66);
  static const Color accentPurple = Color(0xFF9D00FF);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: accentNeonBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentNeonBlue,
        secondary: accentElectricGreen,
        surface: surfaceDark,
        background: backgroundBlack,
      ),
      fontFamily: 'Inter', // Or standard system sans-serif if not loaded
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: surfaceLight, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
