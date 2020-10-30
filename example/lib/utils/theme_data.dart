import 'package:flutter/material.dart';

/// App Color for app
class AppColor {
  /// Fill Color
  static const Color primaryColor = Colors.deepOrange;
  static const Color accentColor = const Color(0xFF168EED);

  /// Text Color
  static const Color textPrimaryColor = Colors.deepOrange;
  static const Color textAccentColor = Colors.deepOrange;
}

/// Text Theme for app
TextTheme _textTheme = TextTheme(
  bodyText2: TextStyle(color: AppColor.textPrimaryColor, fontSize: 18.0),
  headline6: TextStyle(color: Colors.white),
);

/// Theme Data for App
ThemeData myTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: _textTheme,
  fontFamily: 'Josefin Sans',
  primaryColor: AppColor.primaryColor,
  accentColor: AppColor.accentColor,
  // scaffoldBackgroundColor: AppColor.primaryColor,
);
