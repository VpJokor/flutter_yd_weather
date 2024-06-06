import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

extension StringExt on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  bool isNotNullOrEmpty() => !isNullOrEmpty();
}

extension ContextExtension on BuildContext {
  SystemUiOverlayStyle get systemUiOverlayStyle => isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}