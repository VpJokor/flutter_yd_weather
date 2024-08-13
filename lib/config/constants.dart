import 'package:flutter/foundation.dart';

class Constants {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static const String theme = 'AppTheme';
  static const String locale = 'locale';
  static const String appLoadingDialog = 'appLoadingDialog';

  static const String cityDataBox = 'cityDataBox';

  static const String locationCityId = '-66208439';

  static const String currentCityId = 'currentCityId';
  static const String currentCityIdList = 'currentCityIdList';
  static const String currentWeatherCardSort = 'currentWeatherCardSort';
  static const String currentWeatherObservesCardSort = 'currentWeatherObservesCardSort';

  static const int cityDataTypeId = 1;
  static const int simpleWeatherDataTypeId = 2;

  static const int refreshed = -1;
  static const int refreshNone = 0;
  static const int refreshing = 1;
  static const int refreshComplete = 2;

  static const int itemTypeWeatherHeader = 0;
  static const int itemTypeHourWeather = 1;
  static const int itemTypeDailyWeather = 2;
  static const int itemTypeAirQuality = 3;
  static const int itemTypeLifeIndex = 4;
  static const int itemTypeAlarms = 5;
  static const int itemTypeForecast40 = 6;

  /// 紫外线、湿度、体感、风向、日出日落、气压、可见度、未来40日天气
  static const int itemTypeObserve = 7;

  static const int itemTypeObserveUv = 0;
  static const int itemTypeObserveShiDu = 1;
  static const int itemTypeObserveTiGan = 2;
  static const int itemTypeObserveWd = 3;
  static const int itemTypeObserveSunriseSunset = 4;
  static const int itemTypeObservePressure = 5;
  static const int itemTypeObserveVisibility = 6;
  static const int itemTypeObserveForecast40 = 7;

  static const int itemStickyHeight = 32;
  static const int itemObservePanelHeight = 128;

  static const String yyyymmdd = "yyyyMMdd";
  static const String yyyymmddhh = "yyyyMMddHH";
  static const String hhmm = "HH:mm";
  static const String mmdd = "MM/dd";
  static const String yyyy_mm_dd = "yyyy-MM-dd";
  static const String yyyy_mm = "yyyy-MM";
  static const String yyyy_mm_ch = "yyyy年MM月";
  static const String yyyy_ch = "yyyy年";
  static const String yy_mm_dd_hh_mm_ss = "yyMMddHHmmss";
  static const String yyyy_mm_dd_hh_mm = "yyyy-MM-dd HH:mm";
  static const String yyyy_mm_dd_hh_mm_chinese = "yyyy年MM月dd日HH:mm";

  static const defaultWeatherCardSort = [
    "${Constants.itemTypeWeatherHeader}",
    "${Constants.itemTypeAlarms}",
    "${Constants.itemTypeAirQuality}",
    "${Constants.itemTypeHourWeather}",
    "${Constants.itemTypeDailyWeather}",
    "${Constants.itemTypeObserve}",
    "${Constants.itemTypeLifeIndex}",
  ];

  static const defaultWeatherObservesCardSort = [
    "${Constants.itemTypeObserveUv}",
    "${Constants.itemTypeObserveShiDu}",
    "${Constants.itemTypeObserveTiGan}",
    "${Constants.itemTypeObserveWd}",
    "${Constants.itemTypeObserveSunriseSunset}",
    "${Constants.itemTypeObservePressure}",
    "${Constants.itemTypeObserveVisibility}",
    "${Constants.itemTypeObserveForecast40}",
  ];
}
