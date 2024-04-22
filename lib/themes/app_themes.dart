import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    fontFamily: 'Georgia',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      highlightColor: Colors.greenAccent,
      primaryColor: Colors.lightBlue[800],
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium:
            TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
          buttonColor: Colors.greenAccent,
          highlightColor: Colors.greenAccent,
          splashColor: Colors.greenAccent),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.blueGrey,
          shape: CircleBorder()));
}
