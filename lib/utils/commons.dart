import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Commons {
  static Future<bool> exitApp() async {
    await SystemNavigator.pop();
    return Future.value(true);
  }

  static void post(FrameCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  static void postDelayed(VoidCallback callback,
      {int delayMilliseconds = 0}) async {
    await Future.delayed(Duration(milliseconds: delayMilliseconds), callback);
  }

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }

  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }
}