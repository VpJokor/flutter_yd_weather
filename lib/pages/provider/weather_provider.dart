import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

import '../../base/base_list_provider.dart';

class WeatherProvider extends BaseListProvider<WeatherItemData> {
  final _weatherItemTypes = [
    Constants.itemTypeWeatherHeader,
    Constants.itemTypeAlarms,
    Constants.itemTypeAirQuality,
    Constants.itemTypeHourWeather,
    Constants.itemTypeDailyWeather,
    Constants.itemTypeLifeIndex,
    Constants.itemTypeSunriseAndSunset,
  ];

  void setWeatherData(WeatherData? weatherData) {
    final weatherItems = <WeatherItemData>[];
    WeatherItemData buildWeatherItemData(int itemType,
        WeatherData? vWeatherData, List<double> extentInfo) {
      return WeatherItemData(
        itemType: itemType,
        weatherData: vWeatherData,
        maxHeight: extentInfo[0],
        minHeight: extentInfo[1],
      );
    }
    for (var itemType in _weatherItemTypes) {
      final extentInfo = _getPersistentHeaderExtentInfo(itemType);
      if (itemType == Constants.itemTypeAlarms &&
          (weatherData?.alarms.isNotNullOrEmpty() ?? false)) {
        weatherItems.add(buildWeatherItemData(itemType, weatherData, extentInfo));
      } else {
        weatherItems.add(buildWeatherItemData(itemType, weatherData, extentInfo));
      }
    }
    replace(weatherItems);
  }

  List<double> _getPersistentHeaderExtentInfo(int itemType) {
    switch (itemType) {
      case Constants.itemTypeHourWeather:
        return [132.w, 0];
      case Constants.itemTypeDailyWeather:
        return [364.w, 0];
      case Constants.itemTypeAirQuality:
        return [88.w, 0];
      case Constants.itemTypeLifeIndex:
        return [204.w, 0];
      case Constants.itemTypeSunriseAndSunset:
        return [205.w, 0];
      case Constants.itemTypeAlarms:
        return [132.w, 0];
      default:
        return [294.w, 88.w];
    }
  }
}
