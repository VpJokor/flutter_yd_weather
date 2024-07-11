import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';

import '../../base/base_list_provider.dart';

class WeatherProvider extends BaseListProvider<WeatherItemData> {
  final _weatherItemTypes = [
    Constants.itemTypeWeatherHeader,
    Constants.itemTypeHourWeather,
    Constants.itemTypeDailyWeather,
    Constants.itemTypeAirQuality,
    Constants.itemTypeLifeIndex,
    Constants.itemTypeSunriseAndSunset,
  ];

  void setWeatherData(WeatherData? weatherData) {
    final weatherItems = _weatherItemTypes.map(
      (itemType) {
        final extentInfo = _getPersistentHeaderExtentInfo(itemType);
        return WeatherItemData(
          itemType: itemType,
          weatherData: weatherData,
          maxHeight: extentInfo[0],
          minHeight: extentInfo[1],
        );
      },
    ).toList();
    replace(weatherItems);
  }

  List<double> _getPersistentHeaderExtentInfo(int itemType) {
    switch (itemType) {
      case Constants.itemTypeHourWeather:
        return [201.w, 0];
      case Constants.itemTypeDailyWeather:
        return [202.w, 0];
      case Constants.itemTypeAirQuality:
        return [203.w, 0];
      case Constants.itemTypeLifeIndex:
        return [204.w, 0];
      case Constants.itemTypeSunriseAndSunset:
        return [205.w, 0];
      default:
        return [294.w, 88.w];
    }
  }
}
