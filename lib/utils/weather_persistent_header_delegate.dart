import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/widget/weather_air_quality_panel.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_panel.dart';
import 'package:flutter_yd_weather/widget/weather_daily_panel.dart';
import 'package:flutter_yd_weather/widget/weather_hour_panel.dart';
import 'package:flutter_yd_weather/widget/weather_life_index_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_panel.dart';

class WeatherPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  WeatherPersistentHeaderDelegate(
    this.weatherItemData,
    this.showHideWeatherContent,
    this.maxPanelExtent,
    this.currentDailyWeatherType,
    this.changeLineChartDailyWeather,
    this.changeListDailyWeather,
    this.lookMore,
    this.isExpand,
  );

  final WeatherItemData weatherItemData;
  final void Function(bool show)? showHideWeatherContent;
  final double? maxPanelExtent;
  final String? currentDailyWeatherType;
  final VoidCallback? changeLineChartDailyWeather;
  final VoidCallback? changeListDailyWeather;
  final VoidCallback? lookMore;
  final bool? isExpand;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (weatherItemData.itemType == Constants.itemTypeAlarms) {
      return WeatherAlarmsPanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
        showHideWeatherContent: showHideWeatherContent,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeAirQuality) {
      return WeatherAirQualityPanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
        showHideWeatherContent: showHideWeatherContent,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeHourWeather) {
      return WeatherHourPanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeDailyWeather) {
      return WeatherDailyPanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
        currentDailyWeatherType: currentDailyWeatherType,
        changeLineChartDailyWeather: changeLineChartDailyWeather,
        changeListDailyWeather: changeListDailyWeather,
        showHideWeatherContent: showHideWeatherContent,
        lookMore: lookMore,
        isExpand: isExpand,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeObserve) {
      return WeatherObservePanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
        showHideWeatherContent: showHideWeatherContent,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeLifeIndex) {
      return WeatherLifeIndexPanel(
        key: ValueKey(weatherItemData.itemType),
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    }
    return Gaps.empty;
  }

  @override
  double get maxExtent => maxPanelExtent ?? weatherItemData.maxHeight;

  @override
  double get minExtent => weatherItemData.minHeight;

  @override
  bool shouldRebuild(covariant WeatherPersistentHeaderDelegate oldDelegate) {
    final rebuild = this != oldDelegate;
    // Log.e("rebuild = $rebuild");
    return rebuild;
  }
}
