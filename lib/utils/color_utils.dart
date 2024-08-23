import 'dart:ui';
import 'dart:math' as math;

class ColorUtils {
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
}
