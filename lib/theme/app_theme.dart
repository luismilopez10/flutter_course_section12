import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;
  static const Color warning = Color(0xFFE40615);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,

    scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: primary,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: primary,
    )
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    // primaryColor: primary,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
  );
}
