
import 'package:flutter/material.dart';

import 'app_pallete.dart';

class AppTheme {
  static ThemeData lightThemeMode = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPalette.violetDark,
      appBarTheme:
       const AppBarTheme(backgroundColor: AppPalette.transparent),
      textTheme:  const TextTheme(
        displayMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 22,
            color: AppPalette.primaryTextColor,
            height: 1.3),
      ));}