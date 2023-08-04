import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade200,
    textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
      titleSmall: GoogleFonts.sourceSansPro().copyWith(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
      headlineSmall: GoogleFonts.sourceSansPro().copyWith(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.sourceSansPro().copyWith(
        fontSize: 12,
        color: Colors.black,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade200,
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      toolbarTextStyle: const TextStyle(color: Colors.black),
      actionsIconTheme: const IconThemeData(color: Colors.black),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'Raleway',
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
      bodyLarge: TextStyle(
        color: Colors.white70,
      ),
      headlineSmall: TextStyle(
        color: Colors.white70,
      ),
      headlineMedium: TextStyle(color: Colors.white70),
      headlineLarge: TextStyle(color: Colors.white70),
      labelSmall: TextStyle(
        color: Colors.white70,
      ),
      labelMedium: TextStyle(color: Colors.white70),
      labelLarge: TextStyle(color: Colors.white70),
    ),
  );
}
