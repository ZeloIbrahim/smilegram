// couleur de l'appli

import "package:flutter/material.dart";

class AppTheme {
  static const Color _bgClair = Color(0xFFFFF8E7);
  static const Color _cardClair = Color(0xFFFFFFFF);
  static const Color _texteClair = Color(0xFF2E2A1F);
  static const Color _texteSecondaireClair = Color(0xFF6B6355);
  static const Color _bordureClair = Color(0xFFE8DFC8);

  static const Color _bgSombre = Color(0xFF0D1B2A); 
  static const Color _cardSombre = Color(0xFF16283D);
  static const Color _texteSombre = Color(0xFFEDEFF5);
  static const Color _texteSecondaireSombre = Color(0xFF8B96A8);
  static const Color _bordureSombre = Color(0xFF25384F);

  static const Color accent = Color(0xFF7F77DD); 
  static const Color accentClairFill = Color(0xFFEEEDFE);
  static const Color accentClairTexte = Color(0xFF3C3489);
  static const Color accentSombreFill = Color(0xFF3C3489);
  static const Color accentSombreTexte = Color(0xFFCECBF6);
  static const Color secondaireClair = Color(0xFF993556);
  static const Color secondaireSombre = Color(0xFFED93B1);

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _bgClair,
    cardColor: _cardClair,
    colorScheme: const ColorScheme.light(
      primary: accent,
      secondary: secondaireClair,
      surface: _cardClair,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _bgClair,
      foregroundColor: _texteClair,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: _texteClair, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: _texteClair, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: _texteClair, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: _texteClair),
      bodyMedium: TextStyle(color: _texteClair),
      bodySmall: TextStyle(color: _texteSecondaireClair),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _texteClair,
        side: const BorderSide(color: _bordureClair),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _bordureClair)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _bordureClair)),
    ),
    cardTheme: CardThemeData(
      color: _cardClair,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _bordureClair, width: 0.6),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _cardClair,
      indicatorColor: accentClairFill,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(color: states.contains(WidgetState.selected) ? accentClairTexte : _texteSecondaireClair),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected) ? accentClairTexte : _texteSecondaireClair,
        ),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _bgSombre,
    cardColor: _cardSombre,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: secondaireSombre,
      surface: _cardSombre,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _bgSombre,
      foregroundColor: _texteSombre,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: _texteSombre, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: _texteSombre, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: _texteSombre, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: _texteSombre),
      bodyMedium: TextStyle(color: _texteSombre),
      bodySmall: TextStyle(color: _texteSecondaireSombre),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _texteSombre,
        side: const BorderSide(color: _bordureSombre),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _cardSombre,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _bordureSombre)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _bordureSombre)),
    ),
    cardTheme: CardThemeData(
      color: _cardSombre,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _bordureSombre, width: 0.6),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _cardSombre,
      indicatorColor: accentSombreFill,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(color: states.contains(WidgetState.selected) ? accentSombreTexte : _texteSecondaireSombre),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected) ? accentSombreTexte : _texteSecondaireSombre,
        ),
      ),
    ),
  );
}