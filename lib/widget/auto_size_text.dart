import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

class AutoSizeText extends StatelessWidget {
  const AutoSizeText({
    super.key,
    required this.text,
    required this.textStyle,
    this.maxWidth,
  });

  final String text;
  final TextStyle textStyle;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final maxWidth = this.maxWidth;
    double? fitTextSize = textStyle.fontSize;
    if (maxWidth != null) {
      fitTextSize = text.getFitTextSize(textStyle, maxWidth);
    }
    return Text(
      text,
      style: textStyle.copyWith(fontSize: fitTextSize),
    );
  }
}
