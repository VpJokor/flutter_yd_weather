import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

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

  static LoadStateChanged loadStateChanged(
      {Color? placeholder = Colours.colorC5C5C5,
      void Function(ExtendedImageState state)? completed}) {
    return (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          return Container(
            color: placeholder,
            width: state.imageWidget.width,
            height: state.imageWidget.height,
          );
        case LoadState.completed:
          completed?.call(state);
          return state.completedWidget;
        case LoadState.failed:
          return Container(
            color: placeholder,
            width: state.imageWidget.width,
            height: state.imageWidget.height,
          );
      }
    };
  }

  static bool isTomorrow(DateTime dateTime, DateTime locDateTime) {
    if (DateUtil.yearIsEqual(dateTime, locDateTime)) {
      int spDay =
          DateUtil.getDayOfYear(dateTime) - DateUtil.getDayOfYear(locDateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          locDateTime.month == 12 &&
          dateTime.month == 1 &&
          locDateTime.day == 31 &&
          dateTime.day == 1);
    }
  }

  static bool isNight(
    DateTime? dateTime, {
    String? sunrise,
    String? sunset,
  }) {
    if (dateTime == null) return false;
    if (sunrise.isNotNullOrEmpty() &&
        sunrise!.contains(":") &&
        sunset.isNotNullOrEmpty() &&
        sunset!.contains(":")) {
      return _isNight(dateTime, sunrise, sunset);
    }
    return dateTime.hour >= 18 || (dateTime.hour >= 0 && dateTime.hour < 6);
  }

  static bool _isNight(DateTime dateTime, String sunrise, String sunset) {
    final sunriseSplit = sunrise.split(":");
    final sunsetSplit = sunset.split(":");
    final sunriseHour = int.tryParse(sunriseSplit[0]) ?? 0;
    final sunriseMinute = int.tryParse(sunriseSplit[1]) ?? 0;
    final sunsetHour = int.tryParse(sunsetSplit[0]) ?? 0;
    final sunsetMinute = int.tryParse(sunsetSplit[1]) ?? 0;
    final isNight = (dateTime.hour > sunsetHour
            ? true
            : dateTime.hour >= sunsetHour && dateTime.minute > sunsetMinute) ||
        (dateTime.hour < sunriseHour
            ? true
            : dateTime.hour <= sunriseHour && dateTime.minute < sunriseMinute);
    return isNight;
  }

  static List<int>? getSunriseOrSunsetHourMinute(String? sunriseOrSunset) {
    if (sunriseOrSunset.isNullOrEmpty()) return null;
    final sunriseOrSunsetSplit = sunriseOrSunset!.split(":");
    final sunriseOrSunsetHour = int.tryParse(sunriseOrSunsetSplit[0]) ?? 0;
    final sunriseOrSunsetMinute = int.tryParse(sunriseOrSunsetSplit[1]) ?? 0;
    return [sunriseOrSunsetHour, sunriseOrSunsetMinute];
  }
}
