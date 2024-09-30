import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/color_utils.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/weather_bg_utils.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';
import '../model/weather_data.dart';
import '../model/weather_hour_data.dart';
import '../model/weather_item_data.dart';
import 'commons.dart';

class WeatherDataUtils {
  static List<WeatherItemData> generateWeatherItems(
    List<int> weatherSort,
    List<int> weatherObservesCardSort,
    WeatherData? weatherData,
  ) {
    _generateWeatherHourFc(weatherData);
    final weatherItems = weatherSort.map(
      (itemType) {
        final itemTypeObserves = _getItemTypeObserves(
            weatherObservesCardSort, itemType, weatherData);
        final extentInfo = _getPersistentHeaderExtentInfo(
            itemType,
            itemTypeObserves,
            (itemType == Constants.itemTypeDailyWeather ||
                    itemType == Constants.itemTypeLifeIndex)
                ? weatherData
                : null);
        return WeatherItemData(
          itemType: itemType,
          weatherData: weatherData,
          itemTypeObserves: itemTypeObserves,
          maxHeight: extentInfo[0],
          minHeight: extentInfo[1],
          animMaxHeight: extentInfo.getOrNull(2),
        );
      },
    ).toList();
    weatherItems.removeWhere((element) {
      final itemType = element.itemType;
      final removeAlarmsPanel = itemType == Constants.itemTypeAlarms &&
          (weatherData?.alarms.isNullOrEmpty() ?? true);
      final removeAirQualityPanel =
          itemType == Constants.itemTypeAirQuality && weatherData?.evn == null;
      final removeHourPanel = itemType == Constants.itemTypeHourWeather &&
          (weatherData?.hourFc.isNullOrEmpty() ?? true);
      final removeDailyPanel = itemType == Constants.itemTypeDailyWeather &&
          (weatherData?.forecast15.isNullOrEmpty() ?? true);
      final removeObservePanel = itemType == Constants.itemTypeObserve &&
          element.itemTypeObserves.isNullOrEmpty();
      final removeLifeIndexPanel = itemType == Constants.itemTypeLifeIndex &&
          (weatherData?.indexes.isNullOrEmpty() ?? true);
      return removeAlarmsPanel ||
          removeAirQualityPanel ||
          removeHourPanel ||
          removeDailyPanel ||
          removeObservePanel ||
          removeLifeIndexPanel;
    });
    return weatherItems;
  }

  static _generateWeatherHourFc(WeatherData? weatherData) {
    if (weatherData == null) return;
    final hourFc = weatherData.hourFc;
    if (hourFc == null || hourFc.isEmpty) return;
    hourFc.removeWhere(
        (e) => e.sunrise.isNotNullOrEmpty() || e.sunset.isNotNullOrEmpty());
    final currentWeatherDetailData = weatherData.forecast15?.singleOrNull(
      (element) =>
          element.date ==
          DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
    );
    final sunriseIndex = hourFc.indexWhere((e) =>
        currentWeatherDetailData?.sunrise.isSunriseOrSunset(e.time) ?? false);
    if (sunriseIndex >= 0) {
      hourFc.insert(
          sunriseIndex + 1,
          WeatherHourData.sunriseAndSunset(
            sunrise: currentWeatherDetailData?.sunrise,
          ));
    }
    final sunsetIndex = hourFc.indexWhere((e) =>
        currentWeatherDetailData?.sunset.isSunriseOrSunset(e.time) ?? false);
    if (sunsetIndex >= 0) {
      hourFc.insert(
        sunsetIndex + 1,
        WeatherHourData.sunriseAndSunset(
          sunset: currentWeatherDetailData?.sunset,
        ),
      );
    }
  }

  static LinearGradient generateWeatherBg(
    WeatherData? weatherData, {
    String? cacheWeatherType,
    String? cacheSunrise,
    String? cacheSunset,
  }) {
    String weatherType =
        cacheWeatherType ?? (weatherData?.observe?.weatherType ?? "");
    final currentWeatherDetailData = weatherData?.forecast15?.singleOrNull(
      (element) =>
          element.date ==
          DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
    );
    if (weatherType.isNullOrEmpty()) {
      weatherType = currentWeatherDetailData?.weatherType ?? "";
    }
    return WeatherBgUtils.generateWeatherBg(
      weatherType,
      Commons.isNight(
        DateTime.now(),
        sunrise: currentWeatherDetailData?.sunrise ?? cacheSunrise,
        sunset: currentWeatherDetailData?.sunset ?? cacheSunset,
      ),
    );
  }

  static bool isWeatherHeaderDark(LinearGradient? weatherBg) {
    final weatherBgColor = weatherBg?.colors.getOrNull(0);
    return weatherBgColor == null
        ? false
        : ThemeData.estimateBrightnessForColor(weatherBgColor) ==
            Brightness.dark;
  }

  static bool isDark(LinearGradient? weatherBg) {
    final weatherBgColor = weatherBg?.colors.getOrNull(1);
    return weatherBgColor == null
        ? false
        : ThemeData.estimateBrightnessForColor(weatherBgColor) ==
            Brightness.dark;
  }

  static double calPanelOpacity(LinearGradient? weatherBg) {
    final color = weatherBg?.colors.getOrNull(1);
    if (color == null) {
      return 0.1;
    } else {
      final darkness = ColorUtils.getDarkness(color);
      double panelOpacity =
          double.tryParse((0.3 - darkness).abs().toStringAsFixed(1)) ?? 0.1;
      if (panelOpacity < 0.1) panelOpacity = 0.1;
      if (panelOpacity > 0.3) panelOpacity = 0.3;
      debugPrint("darkness = $darkness panelOpacity = $panelOpacity");
      return panelOpacity;
    }
  }

  static double getDarkness(LinearGradient? weatherBg) {
    final weatherBgColor1 = weatherBg?.colors.firstOrNull();
    final weatherBgColor2 = weatherBg?.colors.getOrNull(1);
    return weatherBgColor1 == null || weatherBgColor2 == null
        ? 0
        : ColorUtils.getDarkness(
            ColorUtils.blendColors(weatherBgColor1, weatherBgColor2, 0.5));
  }

  static List<int>? _getItemTypeObserves(
      List<int> currentWeatherObservesCardSort,
      int itemType,
      WeatherData? weatherData) {
    if (weatherData != null && itemType == Constants.itemTypeObserve) {
      final itemTypeObserves = <int>[];
      itemTypeObserves.addAll(currentWeatherObservesCardSort);
      itemTypeObserves.removeWhere((element) {
        final currentWeatherDetailData = weatherData.forecast15?.singleOrNull(
          (element) =>
              element.date ==
              DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
        );
        int uvIndex = weatherData.observe?.uvIndex ?? 0;
        int uvIndexMax = weatherData.observe?.uvIndexMax ?? 0;
        String uvLevel = weatherData.observe?.uvLevel ?? "";
        if (uvIndex <= 0 || uvIndexMax <= 0 || uvLevel.isEmpty) {
          uvIndex = currentWeatherDetailData?.uvIndex ?? 0;
          uvIndexMax = currentWeatherDetailData?.uvIndexMax ?? 0;
          uvLevel = currentWeatherDetailData?.uvLevel ?? "0";
        }
        final removeUvPanel = element == Constants.itemTypeObserveUv &&
            (uvIndex <= 0 || uvIndexMax <= 0 || uvLevel.isEmpty);
        final removeShiDuPanel = element == Constants.itemTypeObserveShiDu &&
            (weatherData.observe?.shiDu.isNullOrEmpty() ?? true);
        final removeTiGanPanel = element == Constants.itemTypeObserveTiGan &&
            (weatherData.observe?.tiGan.isNullOrEmpty() ?? true);
        final removeWdPanel = element == Constants.itemTypeObserveWd &&
            ((weatherData.observe?.wd.isNullOrEmpty() ?? true) ||
                (weatherData.observe?.wp.isNullOrEmpty() ?? true));
        final removeSunriseSunsetPanel =
            element == Constants.itemTypeObserveSunriseSunset &&
                ((currentWeatherDetailData?.sunrise.isNullOrEmpty() ?? true) ||
                    (currentWeatherDetailData?.sunset.isNullOrEmpty() ?? true));
        final removePressurePanel =
            element == Constants.itemTypeObservePressure &&
                (weatherData.observe?.pressure.isNullOrEmpty() ?? true);
        final removeVisibilityPanel = element ==
                Constants.itemTypeObserveVisibility &&
            ((weatherData.observe?.visibility.isNullOrEmpty() ?? true) ||
                (currentWeatherDetailData?.visibility.isNullOrEmpty() ?? true));
        final removeForecast40Panel =
            element == Constants.itemTypeObserveForecast40 &&
                weatherData.forecast40Data == null;
        return removeUvPanel ||
            removeShiDuPanel ||
            removeTiGanPanel ||
            removeWdPanel ||
            removeSunriseSunsetPanel ||
            removePressurePanel ||
            removeVisibilityPanel ||
            removeForecast40Panel;
      });
      return itemTypeObserves;
    }
    return null;
  }

  static List<double> _getPersistentHeaderExtentInfo(
      int itemType, List<int>? itemTypeObserves, WeatherData? weatherData) {
    switch (itemType) {
      case Constants.itemTypeHourWeather:
        return [132.w, 0];
      case Constants.itemTypeDailyWeather:
        final currentDailyWeatherType = SpUtil.getString(
                Constants.currentDailyWeatherType,
                defValue: Constants.listDailyWeather) ??
            Constants.listDailyWeather;
        final listDailyWeatherMaxHeight = Constants.itemStickyHeight.w +
            Constants.dailyWeatherItemHeight.w *
                min(
                    Constants.dailyWeatherItemCount,
                    weatherData?.forecast15?.length ??
                        Constants.dailyWeatherItemCount) +
            Constants.dailyWeatherBottomHeight.w;
        final find = weatherData?.forecast15?.singleOrNull(
            (element) => element.aqiLevelName.isNotNullOrEmpty());
        final lineChartDailyWeatherMaxHeight = find != null ? 402.w : 382.w;
        if (currentDailyWeatherType == Constants.listDailyWeather) {
          return [
            listDailyWeatherMaxHeight,
            0,
            lineChartDailyWeatherMaxHeight,
          ];
        } else {
          return [
            lineChartDailyWeatherMaxHeight,
            0,
            listDailyWeatherMaxHeight,
          ];
        }
      case Constants.itemTypeAirQuality:
        return [88.w, 0];
      case Constants.itemTypeLifeIndex:
        final length = weatherData?.indexes?.length ?? 0;
        final columnHeight = (ScreenUtil().screenWidth - 2 * 16.w) / 3;
        final height =
            (length / 3).ceil() * columnHeight + Constants.itemStickyHeight;
        return [height, 0];
      case Constants.itemTypeAlarms:
        return [132.w, 0];
      case Constants.itemTypeForecast40:
        return [158.w, 0];
      case Constants.itemTypeObserve:
        final length = itemTypeObserves?.length ?? 0;
        final count = (length / 2).ceil();
        final height =
            count * Constants.itemObservePanelHeight.w + (count - 1) * 12.w;
        return [height, 0];
      default:
        return [294.w, 88.w];
    }
  }
}
