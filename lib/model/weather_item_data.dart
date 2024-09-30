import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';

class WeatherItemData {
  int itemType = Constants.itemTypeWeatherHeader;
  WeatherData? weatherData;
  List<int>? itemTypeObserves;
  double maxHeight;
  double minHeight;
  double? animMaxHeight;

  WeatherItemData({
    this.itemType = Constants.itemTypeWeatherHeader,
    this.weatherData,
    this.maxHeight = 0,
    this.minHeight = 0,
    this.itemTypeObserves,
    this.animMaxHeight,
  });

  @override
  bool operator ==(Object other) =>
      other is WeatherItemData && itemType == other.itemType;

  @override
  int get hashCode => itemType.hashCode;
}
