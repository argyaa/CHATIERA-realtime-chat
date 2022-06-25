import 'package:flutter/material.dart';

Color blue = const Color(0xff47BFED);
Color grey = const Color(0xffC6C6C6);

final ThemeData light = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: Colors.white,
        secondary: blue,
        brightness: Brightness.light,
      ),
  appBarTheme: AppBarTheme(backgroundColor: blue),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: Colors.grey[400])),
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: blue)),
);

final ThemeData dark = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xff1B2430),
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: const Color(0xff1B2430),
        secondary: blue,
        brightness: Brightness.dark,
      ),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xff1B2430)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: const Color(0xff293B5F))),
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: blue)),
);
