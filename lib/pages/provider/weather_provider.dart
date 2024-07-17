import 'package:common_utils/common_utils.dart';
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
    Constants.itemTypeObserve,
    Constants.itemTypeLifeIndex,
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
      return removeAlarmsPanel ||
          removeAirQualityPanel ||
          removeHourPanel ||
          removeDailyPanel;
    });
    replace(weatherItems);
  }

  List<double> _getPersistentHeaderExtentInfo(int itemType) {
    switch (itemType) {
      case Constants.itemTypeHourWeather:
        return [124.w, 0];
      case Constants.itemTypeDailyWeather:
        return [394.w, 0];
      case Constants.itemTypeAirQuality:
        return [88.w, 0];
      case Constants.itemTypeLifeIndex:
        return [204.w, 0];
      case Constants.itemTypeAlarms:
        return [132.w, 0];
      case Constants.itemTypeForecast40:
        return [158.w, 0];
      case Constants.itemTypeObserve:
        return [158.w, 0];
      default:
        return [294.w, 88.w];
    }
  }

  List<int> _getItemTypeObserves(int itemType, WeatherData? weatherData) {
    if (weatherData != null && itemType == Constants.itemTypeObserve) {
      final itemTypeObserves = [
        Constants.itemTypeObserveUv,
        Constants.itemTypeObserveShiDu,
        Constants.itemTypeObserveTiGan,
        Constants.itemTypeObserveWd,
        Constants.itemTypeObserveSunriseSunset,
        Constants.itemTypeObservePressure,
        Constants.itemTypeObserveVisibility,
        Constants.itemTypeObserveForecast40,
      ];
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
        final removeUvPanel =
            uvIndex <= 0 || uvIndexMax <= 0 || uvLevel.isEmpty;
        final removeShiDuPanel =
            weatherData.observe?.shiDu.isNullOrEmpty() ?? true;
        final removeTiGanPanel =
            weatherData.observe?.tiGan.isNullOrEmpty() ?? true;
        final removeWdPanel =
            (weatherData.observe?.wd.isNullOrEmpty() ?? true) ||
                (weatherData.observe?.wp.isNullOrEmpty() ?? true);
        final removeSunriseSunsetPanel =
            (currentWeatherDetailData?.sunrise.isNullOrEmpty() ?? true) ||
                (currentWeatherDetailData?.sunset.isNullOrEmpty() ?? true);
        final removePressurePanel =
            weatherData.observe?.pressure.isNullOrEmpty() ?? true;
        final removeVisibilityPanel =
            (weatherData.observe?.visibility.isNullOrEmpty() ?? true) ||
                (currentWeatherDetailData?.visibility.isNullOrEmpty() ?? true);
        final removeForecast40Panel = weatherData.forecast40Data == null;
        return removeUvPanel ||
            removeShiDuPanel ||
            removeTiGanPanel ||
            removeWdPanel ||
            removeSunriseSunsetPanel ||
            removePressurePanel ||
            removeVisibilityPanel ||
            removeForecast40Panel;
      });
    }
    return [];
  }
}
