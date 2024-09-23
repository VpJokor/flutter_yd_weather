import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter_yd_weather/res/colours.dart';

class ColorUtils {
  /// 颜色检测只保存 #RRGGBB格式 FF透明度
  /// [color] 格式可能是材料风/十六进制/string字符串
  /// 返回[String] #rrggbb 字符串
  static String color2HEX(
    Color? color, {
    String defColor = "#FFFFFF",
    bool toUpperCase = false,
  }) {
    if (color == null) {
      return defColor;
    }
    // 0xFFFFFFFF
    // 将十进制转换成为16进制 返回字符串但是没有0x开头
    String temp = color.value.toRadixString(16);
    final result = "#${temp.substring(2, 8)}";
    return toUpperCase ? result.toUpperCase() : result;
  }

  static Color? getColorFromHex(String? hexColor, {Color? defColor}) {
    if (hexColor == null || hexColor.isEmpty) return defColor;
    if (hexColor.length != 6 && hexColor.length != 8) return defColor;
    if (hexColor.startsWith("#")) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
    } else {
      hexColor = hexColor.toUpperCase();
    }
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (err) {
      return defColor;
    }
  }

  static Color adjustAlpha(Color color, double factor) {
    final alpha = color.alpha * factor;
    return Color.fromARGB(alpha.round(), color.red, color.green, color.blue);
  }

  static Color blendColors(Color color1, Color color2, double ratio) {
    final inverseRatio = 1 - ratio;
    final a = color1.alpha * inverseRatio + color2.alpha * ratio;
    final r = color1.red * inverseRatio + color2.red * ratio;
    final g = color1.green * inverseRatio + color2.green * ratio;
    final b = color1.blue * inverseRatio + color2.blue * ratio;
    return Color.fromARGB(a.toInt(), r.toInt(), g.toInt(), b.toInt());
  }

  static double getDarkness(Color color) {
    return 1 -
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  }

  static double calSimilarity(Color color1, Color color2) {
    final r1 = color1.red;
    final g1 = color1.green;
    final b1 = color1.blue;

    final r2 = color2.red;
    final g2 = color2.green;
    final b2 = color2.blue;

    final distance = math.sqrt(
        math.pow(r1 - r2, 2) + math.pow(g1 - g2, 2) + math.pow(b1 - b2, 2));
    return 1 - distance / 255 / math.sqrt(3);
  }
}
