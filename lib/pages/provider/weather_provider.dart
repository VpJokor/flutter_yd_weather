import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/model/weather_hour_data.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/weather_data_utils.dart';

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
    _weatherBg = WeatherDataUtils.generateWeatherBg(weatherData);
    _isDark = WeatherDataUtils.isDark(_weatherBg);
    final weatherItems = WeatherDataUtils.generateWeatherItems(
        currentWeatherSort, currentWeatherObservesCardSort, weatherData);
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
    String? cacheSunrise,
    String? cacheSunset,
  }) {
    _weatherBg = WeatherDataUtils.generateWeatherBg(
      weatherData,
      cacheWeatherType: cacheWeatherType,
      cacheSunrise: cacheSunrise,
      cacheSunset: cacheSunset,
    );
    _isDark = WeatherDataUtils.isDark(_weatherBg);
  }

}
