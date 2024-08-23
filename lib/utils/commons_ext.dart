import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

import '../config/constants.dart';
import '../net/api.dart';
import '../net/net_utils.dart';

extension StringExt on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  bool isNotNullOrEmpty() => !isNullOrEmpty();

  int getShiDuValue() {
    if (isNullOrEmpty()) return 0;
    if (this!.contains("%")) {
      return int.tryParse(this!.replaceAll("%", "")) ?? 0;
    }
    return 0;
  }

  double getVisibilityValue() {
    if (isNullOrEmpty()) return 0;
    if (this!.toUpperCase().contains("KM")) {
      return double.tryParse(this!.replaceAll("KM", "")) ?? 0;
    }
    if (this!.toUpperCase().contains("M")) {
      return double.tryParse(this!.replaceAll("M", "")) ?? 0;
    }
    return 0;
  }

  String getVisibilityUnit() {
    if (isNullOrEmpty()) return "";
    if (this!.toUpperCase().contains("KM")) {
      return "公里";
    }
    if (this!.toUpperCase().contains("M")) {
      return "米";
    }
    return "";
  }

  String getVisibilityDesc(double visibilityValue) {
    if (isNullOrEmpty()) return "";
    if (this!.toUpperCase().contains("KM")) {
      if (visibilityValue <= 1) {
        return "视野较差";
      }
      return "视野非常好";
    }
    if (this!.toUpperCase().contains("M")) {
      if (visibilityValue <= 1000) {
        return "视野较差";
      }
      return "视野非常好";
    }
    return "";
  }

  /// 202407111400 => 20240711T140000
  String getDartDateTimeFormattedString() {
    if (isNullOrEmpty()) return "";
    if (this!.length != 12) return "";
    return "${this!.substring(0, 8)}T${this!.substring(8)}00";
  }

  String getWeatherHourTime({String? sunrise, String? sunset}) {
    final isHourNow = this.isHourNow();
    if (isHourNow) {
      final sunriseHourMinute = Commons.getSunriseOrSunsetHourMinute(sunrise);
      final sunsetHourMinute = Commons.getSunriseOrSunsetHourMinute(sunset);
      if (sunriseHourMinute.isNotNullOrEmpty() &&
          sunsetHourMinute.isNotNullOrEmpty()) {
        final now = DateTime.now();
        final sunriseDateTime = DateTime(now.year, now.month, now.day,
            sunriseHourMinute![0], sunriseHourMinute[1]);
        final sunsetDateTime = DateTime(now.year, now.month, now.day,
            sunsetHourMinute![0], sunsetHourMinute[1]);
        final isAfterSunrise = now.isAfter(sunriseDateTime);
        final isAfterSunset = now.isAfter(sunsetDateTime);
        if (isAfterSunrise || isAfterSunset) {
          return DateUtil.formatDateStr(this!.getDartDateTimeFormattedString(),
              format: "HH时");
        }
      }
      return "现在";
    }
    return DateUtil.formatDateStr(this!.getDartDateTimeFormattedString(),
        format: "HH时");
  }

  bool isSunriseOrSunset(String? time) {
    if (isNullOrEmpty()) return false;
    if (time.isNullOrEmpty()) return false;
    return this!.startsWith(DateUtil.formatDateStr(
        time!.getDartDateTimeFormattedString(),
        format: "HH"));
  }

  String getWeatherDateTime() {
    if (isNullOrEmpty()) return "";
    final dateTime = DateTime.tryParse(this!);
    if (dateTime == null) return "";
    final isYesterday = DateUtil.isYesterday(dateTime, DateTime.now());
    if (isYesterday) return "昨天";
    final isToday = DateUtil.isToday(dateTime.millisecondsSinceEpoch);
    if (isToday) return "今天";
    final isTomorrow = Commons.isTomorrow(dateTime, DateTime.now());
    if (isTomorrow) return "明天";
    return DateUtil.getWeekday(dateTime, languageCode: "zh", short: true);
  }

  bool isToday() {
    if (isNullOrEmpty()) return false;
    final dateTime = DateTime.tryParse(this!);
    if (dateTime == null) return false;
    return DateUtil.isToday(dateTime.millisecondsSinceEpoch);
  }

  bool isYesterday() {
    if (isNullOrEmpty()) return false;
    final dateTime = DateTime.tryParse(this!);
    if (dateTime == null) return false;
    return DateUtil.isYesterday(dateTime, DateTime.now());
  }

  bool isBefore() {
    if (isNullOrEmpty()) return false;
    final dateTime = DateTime.tryParse(this!);
    if (dateTime == null) return false;
    final now = DateTime.now();
    return dateTime.isBefore(DateTime(now.year, now.month, now.day));
  }

  /// 年月日小时相同
  bool isHourNow() {
    if (isNullOrEmpty()) return false;
    final nowTimeStr =
        DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmddhh);
    final dateTimeStr = DateUtil.formatDateStr(
        this!.getDartDateTimeFormattedString(),
        format: Constants.yyyymmddhh);
    return nowTimeStr == dateTimeStr;
  }

  bool isNight({
    String? sunrise,
    String? sunset,
  }) {
    if (isNullOrEmpty()) return false;
    final dateTime = DateTime.tryParse(this!.getDartDateTimeFormattedString());
    return Commons.isNight(
      dateTime,
      sunrise: sunrise,
      sunset: sunset,
    );
  }

  double getTextContextSizeHeight(
    TextStyle textStyle, {
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
    Locale? locale,
    double maxWidth = double.infinity,
  }) {
    TextPainter textPainter = TextPainter(
      // 用于选择用户的语言和格式首选项的标识符。
      locale: locale,
      // 最大行数
      maxLines: maxLines,
      // 文本书写方向l to r 汉字从左到右
      textDirection: textDirection,
      // 文本内容以及文本样式 style:可以根据在代码中设置的TextStyle增加字段。
      text: TextSpan(
        text: this,
        style: textStyle,
      ),
    );
    // 最大宽度
    textPainter.layout(maxWidth: maxWidth);
    // 返回高度
    return textPainter.height;
  }

  double getTextContextSizeWidth(
    TextStyle textStyle, {
    int? maxLines,
    TextDirection textDirection = TextDirection.ltr,
    Locale? locale,
    double maxWidth = double.infinity,
  }) {
    TextPainter textPainter = TextPainter(
      // 用于选择用户的语言和格式首选项的标识符。
      locale: locale,
      // 最大行数
      maxLines: maxLines,
      // 文本书写方向l to r 汉字从左到右
      textDirection: textDirection,
      // 文本内容以及文本样式 style:可以根据在代码中设置的TextStyle增加字段。
      text: TextSpan(
        text: this,
        style: textStyle,
      ),
    );
    // 最大宽度
    textPainter.layout(maxWidth: maxWidth);
    // 返回高度
    return textPainter.width;
  }

  bool isRain() {
    if (isNullOrEmpty()) return false;
    switch (this!) {
      case "LIGHT_RAIN":
      case "MODERATE_RAIN":
      case "HEAVY_RAIN":
      case "STORM_RAIN":
        return true;
    }
    return false;
  }
}

extension IntExt on int? {
  String getTemp() {
    return this == null ? "" : "$this°";
  }

  Color getAqiColor() {
    final aqi = this ?? 0;
    if (aqi <= 50) {
      return Colours.color00E301;
    } else if (aqi > 50 && aqi <= 100) {
      return Colours.colorFDFD01;
    } else if (aqi > 100 && aqi <= 150) {
      return Colours.colorFD7E01;
    } else if (aqi > 150 && aqi <= 200) {
      return Colours.colorF70001;
    } else if (aqi > 200 && aqi <= 300) {
      return Colours.color98004C;
    } else {
      return Colours.color7D0023;
    }
  }

  String getShiDuDesc() {
    if (this == null) return "";
    if (this! < 40) return "干燥";
    if (this! < 70) return "舒适";
    return "潮湿";
  }
}

extension DoubleExt on double? {
  double fixPercent({double defValue = 0}) {
    if (this == null) return defValue;
    if (this! > 1) return 1;
    if (this! < 0) return 0;
    return this!;
  }

  double positiveNumber() {
    if (this == null) return 0;
    return this! < 0 ? 0 : this!;
  }

  double negativeNumber() {
    if (this == null) return 0;
    return this! > 0 ? 0 : this!;
  }
}

extension ContextExtension on BuildContext {
  SystemUiOverlayStyle get systemUiOverlayStyle =>
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

extension ListExt<E> on List<E>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  bool isNotNullOrEmpty() => !this.isNullOrEmpty();

  E? singleOrNull(bool Function(E element) test) {
    if (this == null) return null;
    E? single;
    bool found = false;
    for (var element in this!) {
      if (test(element)) {
        if (found) continue;
        single = element;
        found = true;
      }
    }
    if (!found) return null;
    return single;
  }

  E? getOrNull(int index) {
    if (this == null) return null;
    return index >= 0 && index <= this!.length - 1 ? this![index] : null;
  }

  E? firstOrNull() {
    return getOrNull(0);
  }

  void forEachIndexed(void Function(E element, int index) action) {
    if (this == null) return;
    int index = 0;
    for (E element in this!) {
      action(element, index);
      index++;
    }
  }

  List<T> mapIndexed<T>(T Function(E element, int index) action) {
    if (this == null) return <T>[];
    int index = 0;
    return this!.map((e) => action(e, index++)).toList();
  }
}

extension NetExt<E> on void {
  void searchCity(String searchKey, void Function(List<CityData>? result) block,
      {bool showLoading = true}) {
    if (showLoading) {
      Commons.showLoading();
    }
    final Map<String, String> params = <String, String>{};
    params["keyword"] = searchKey;
    NetUtils.instance.requestNetwork<List<CityData>>(
        Method.post, Api.searchCityApi, queryParameters: params,
        onSuccess: (data) {
      if (showLoading) {
        Commons.hideLoading();
      }
      block.call(data);
    }, onError: (msg) {
      if (showLoading) {
        Commons.hideLoading();
      }
      block.call(null);
    });
  }

  Future<List<CityData>?> searchCityResult(String searchKey,
      {bool showLoading = true}) async {
    if (showLoading) {
      Commons.showLoading();
    }
    final Map<String, String> params = <String, String>{};
    params["keyword"] = searchKey;
    final result = await NetUtils.instance.requestNet<List<CityData>>(
        Method.post, Api.searchCityApi,
        queryParameters: params);
    if (showLoading) {
      Commons.hideLoading();
    }
    return Future.value(result);
  }
}
