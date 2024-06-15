import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../config/constants.dart';
import '../res/colours.dart';

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

  static void showLoading({String tag = Constants.appLoadingDialog}) {
    SmartDialog.show(
      tag: tag,
      maskColor: Colours.transparent,
      builder: (_) {
        return CupertinoActivityIndicator(
          animating: true,
          radius: 12.w,
        );
      },
    );
  }

  static void hideLoading({String tag = Constants.appLoadingDialog}) {
    SmartDialog.dismiss(tag: tag);
  }
}