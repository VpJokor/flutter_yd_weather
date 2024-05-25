import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import '../config/constants.dart';
import '../res/colours.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode getThemeMode() {
    final String theme = SpUtil.getString(Constants.theme) ?? '';
    switch (theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      useMaterial3: false,
      primaryColor: isDarkMode ? Colours.darkAppMain : Colours.appMain,
    );
  }
}
