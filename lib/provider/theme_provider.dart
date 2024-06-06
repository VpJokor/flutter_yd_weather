import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        secondary: isDarkMode ? Colours.darkAppMain : Colours.appMain,
        error: isDarkMode ? Colours.colorFE2C3C : Colours.colorFE2C3C,
      ),
      // Tab指示器颜色
      indicatorColor: isDarkMode ? Colours.darkAppMain : Colours.appMain,
      // 页面背景色
      scaffoldBackgroundColor:
          isDarkMode ? Colours.darkBgColor : Colours.bgColor,
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colours.darkMaterialBg : Colours.bgColor,
      // 文字选择色（输入框选择文字等）
      // textSelectionColor: Colours.app_main.withAlpha(70),
      // textSelectionHandleColor: Colours.app_main,
      // 稳定版：1.23 变更(https://flutter.dev/docs/release/breaking-changes/text-selection-theme)
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.appMain.withAlpha(70),
        selectionHandleColor: Colours.appMain,
        cursorColor: Colours.appMain,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: isDarkMode ? Colours.darkBgColor : Colours.bgColor,
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.darkLine : Colours.line,
        space: 0.5.w,
        thickness: 0.5.w,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      visualDensity: VisualDensity
          .standard, // https://github.com/flutter/flutter/issues/77142
    );
  }
}
