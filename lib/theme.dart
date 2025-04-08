import 'package:flutter/material.dart';

final DarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[500],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  textTheme: TextTheme(
      bodyMedium: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      labelLarge: const TextStyle(
        fontSize: 30,
        color: Colors.green,
      ),
      labelSmall: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      )),
  useMaterial3: true
);
