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
        return [200.w, 100.w];
      case Constants.itemTypeDailyWeather:
        return [200.w, 100.w];
      case Constants.itemTypeAirQuality:
        return [200.w, 100.w];
      case Constants.itemTypeLifeIndex:
        return [200.w, 100.w];
      case Constants.itemTypeSunriseAndSunset:
        return [200.w, 100.w];
      default:
        return [200.w, 100.w];
    }
  }
}
