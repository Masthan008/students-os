import 'package:flutter/material.dart';

class AppTheme {
  static const Color midnightBlue = Color(0xFF191970); // Deep Midnight Blue
  static const Color deepViolet = Color(0xFF4B0082); // Deep Violet
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.white70;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent, // Important for gradient background
      primaryColor: deepViolet,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textWhite, fontFamily: 'Roboto'), // Using default font for now, can be updated
        bodyMedium: TextStyle(color: textWhite, fontFamily: 'Roboto'),
        displayLarge: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
      ),
      colorScheme: const ColorScheme.dark(
        primary: deepViolet,
        secondary: midnightBlue,
        surface: Colors.transparent,
      ),
      useMaterial3: true,
    );
  }

  static BoxDecoration get backgroundDecoration {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          midnightBlue,
          Color(0xFF2E004F), // Darker Violet
          deepViolet,
          Color(0xFF000033), // Almost Black Blue
        ],
      ),
    );
  }
}
