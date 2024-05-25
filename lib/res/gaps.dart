import 'package:flutter/material.dart';

/// 间隔
/// 官方做法：https://github.com/flutter/flutter/pull/54394
class Gaps {
  static SizedBox generateGap({double? width, double? height}) =>
      SizedBox(width: width, height: height);

  static Divider generateDivider(
          {double? height, double? thickness, Color? color}) =>
      Divider(
        height: height,
        thickness: thickness ?? height,
        color: color,
      );

  static VerticalDivider generateVerticalDivider(
          {double? width, double? thickness, Color? color}) =>
      VerticalDivider(
        width: width,
        thickness: thickness ?? width,
        color: color,
      );

//  static Widget line = const SizedBox(
//    height: 0.6,
//    width: double.infinity,
//    child: const DecoratedBox(decoration: BoxDecoration(color: Colours.line)),
//  );

  static const Widget line = Divider();

  static const Widget vLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: VerticalDivider(),
  );

  static const Widget empty = SizedBox.shrink();

  /// 补充一种空Widget实现 https://github.com/letsar/nil
  /// https://github.com/flutter/flutter/issues/78159
}
