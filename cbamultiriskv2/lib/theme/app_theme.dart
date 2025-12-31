import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    primaryColor: Color(0xFF2B70C9),
    secondaryHeaderColor: Color(0XFF225AA1),
    cardColor: Color(0xFFF7F7F7),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFF4B4B4B)
      )
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF4C89D9),
      brightness: Brightness.light
    )
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF4B4B4B),
    primaryColor: Color(0xFF2B70C9),
    secondaryHeaderColor: Color(0XFF225AA1),
    cardColor: Color(0xFF4B4B4B),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xFFF7F7F7)
      )
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF4C89D9),
      brightness: Brightness.dark
    )
  );
}