import 'package:flutter/material.dart';

import 'package:seccion12_fluttercourse/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({required bool isDarkmode})
      : currentTheme = isDarkmode ? AppTheme.darkTheme : AppTheme.lightTheme;

  setLightmode() {
    currentTheme = AppTheme.lightTheme;
    notifyListeners();
  }

  setDarkmode() {
    currentTheme = AppTheme.darkTheme;
    notifyListeners();
  }
}
