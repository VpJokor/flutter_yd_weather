import 'dart:io';

import 'package:flutter/foundation.dart';

class Device {
  static bool get isIOS => Platform.isIOS || true;
  static bool get isAndroid => Platform.isAndroid;
  static bool get isWeb => kIsWeb;
}