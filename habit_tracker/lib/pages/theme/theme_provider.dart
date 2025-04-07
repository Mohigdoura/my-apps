import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/theme/dark_mode.dart';
import 'package:habit_tracker/pages/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initially light mode
  ThemeData _themeData = darkMode;

  // get current theme
  ThemeData get themeData => _themeData;

  // is dark?
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
  // toggle theme

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
