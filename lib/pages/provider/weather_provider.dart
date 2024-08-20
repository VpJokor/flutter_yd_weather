import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

import '../../base/base_list_provider.dart';
import '../../utils/commons.dart';
import '../../utils/weather_bg_utils.dart';

class WeatherProvider extends BaseListProvider<WeatherItemData> {
  LinearGradient? _weatherBg;

  LinearGradient? get weatherBg => _weatherBg;

  bool _isDark = false;

  bool get isDark => _isDark;

  void setWeatherData(List<int> currentWeatherSort,
      List<int> currentWeatherObservesCardSort, WeatherData? weatherData) {
    generateWeatherBg(weatherData);
    final weatherItems = currentWeatherSort.map(
      (itemType) {
        final itemTypeObserves = _getItemTypeObserves(
            currentWeatherObservesCardSort, itemType, weatherData);
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
    replace(weatherItems);
  }

  void reorder(List<int> currentWeatherSort) {
    final newWeatherItems = <WeatherItemData>[];
    for (var itemType in currentWeatherSort) {
      final find = list.singleOrNull((e) => e.itemType == itemType);
      if (find != null) newWeatherItems.add(find);
    }
    replace(newWeatherItems);
  }

  void reorderObserves(
      List<int> currentWeatherSort, List<int> currentWeatherObservesCardSort) {
    setWeatherData(currentWeatherSort, currentWeatherObservesCardSort,
        list.firstOrNull()?.weatherData);
  }

  void generateWeatherBg(
    WeatherData? weatherData, {
    String? cacheWeatherType,
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
    _weatherBg = WeatherBgUtils.getWeatherBg(
      weatherType,
      Commons.isNight(
        DateTime.now(),
        sunrise: currentWeatherDetailData?.sunrise,
        sunset: currentWeatherDetailData?.sunset,
      ),
    );
    final weatherBgColor = weatherBg?.colors.firstOrNull();
    _isDark = weatherBgColor == null
        ? false
        : ThemeData.estimateBrightnessForColor(weatherBgColor) ==
            Brightness.dark;
  }

  List<double> _getPersistentHeaderExtentInfo(
      int itemType, List<int>? itemTypeObserves, WeatherData? weatherData) {
    switch (itemType) {
      case Constants.itemTypeHourWeather:
        return [124.w, 0];
      case Constants.itemTypeDailyWeather:
        final find = weatherData?.forecast15?.singleOrNull(
            (element) => element.aqiLevelName.isNotNullOrEmpty());
        return [find != null ? 394.w : 374.w, 0];
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

  List<int>? _getItemTypeObserves(List<int> currentWeatherObservesCardSort,
      int itemType, WeatherData? weatherData) {
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
}
