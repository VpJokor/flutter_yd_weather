import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

class ImageUtils {
  static String getImgPath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }
}

extension ImageExtension on BuildContext {
  String get splash => isDark ? "dark/splash" : "splash";
  String get weatherBg => isDark ? "dark/ic_weather_bg" : "ic_weather_bg";
}
