import 'package:flutter/material.dart';
import 'package:to_do/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // intial state
  ThemeData _themeData = lightMode;

  // getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // getter method to see if we are in dark mode ot not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // used in a switch
  void toggleTheme() {
    _themeData == lightMode ? themeData = darkMode : themeData = lightMode;
  }
}
