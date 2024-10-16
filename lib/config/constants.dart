import 'package:flutter/foundation.dart';
import 'package:flutter_yd_weather/model/weather_bg_model.dart';

import '../res/colours.dart';

class Constants {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static const String theme = 'AppTheme';
  static const String locale = 'locale';
  static const String appLoadingDialog = 'appLoadingDialog';


  static const int maxCityListLength = 20;

  static const String cityDataBox = 'cityDataBox';

  static const String locationCityId = '-66208439';

  static const String currentCityId = 'currentCityId';
  static const String currentCityIdList = 'currentCityIdList';
  static const String currentWeatherCardSort = 'currentWeatherCardSort';
  static const String currentWeatherObservesCardSort =
      'currentWeatherObservesCardSort';
  static const String currentWeatherBgMap = 'currentWeatherBgMap';
  static const String currentDailyWeatherType = 'currentDailyWeatherType';
  static const String lineChartDailyWeather = 'lineChartDailyWeather';
  static const String listDailyWeather = 'listDailyWeather';

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
  static const int dailyWeatherItemHeight = 48;
  static const int dailyWeatherItemCount = 10;
  static const int dailyWeatherBottomHeight = 32;

  static const int maxWeatherBgCount = 6;

  static const String dd = "dd";
  static const String yyyymmdd = "yyyyMMdd";
  static const String yyyymmddhh = "yyyyMMddHH";
  static const String hhmm = "HH:mm";
  static const String mmdd = "MM/dd";
  static const String mm_dd = "MM月dd日";
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

  static Map<String, List<WeatherBgModel>> defaultWeatherBgMap = {
    "CLEAR": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorF47359.value,
          Colours.colorF1AB80.value,
        ],
        nightColors: [
          Colours.color1A1B30.value,
          Colours.color2E3C54.value,
        ],
      ),
    ],
    "PARTLY_CLOUDY": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorABB7C4.value,
          Colours.colorB6C7CD.value,
        ],
        nightColors: [
          Colours.color2E336C.value,
          Colours.color64648D.value,
        ],
      ),
    ],
    "CLOUDY": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.color58677F.value,
          Colours.color828D9E.value,
        ],
        nightColors: [
          Colours.color1E2232.value,
          Colours.color354359.value,
        ],
      ),
    ],
    "LIGHT_HAZE": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorBC8E3E.value,
          Colours.colorE5BB62.value,
        ],
      ),
    ],
    "HEAVY_HAZE": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorB77B32.value,
          Colours.colorF7BA66.value,
        ],
      ),
    ],
    "LIGHT_RAIN": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.color5E738D.value,
          Colours.color8F9AAD.value,
        ],
        nightColors: [
          Colours.color171A2A.value,
          Colours.color3C4354.value,
        ],
      ),
    ],
    "MODERATE_RAIN": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.color171A2A.value,
          Colours.color3C4354.value,
        ],
      ),
    ],
    "FOG": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorABB7C4.value,
          Colours.colorB6C7CD.value,
        ],
      ),
    ],
    "LIGHT_SNOW": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorABB7C4.value,
          Colours.colorB6C7CD.value,
        ],
      ),
    ],
    "DUST": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.colorF7CB6A.value,
          Colours.colorFDA085.value,
        ],
      ),
    ],
    "WIND": [
      WeatherBgModel(
        isSelected: true,
        colors: [
          Colours.color4776B0.value,
          Colours.colorE9A4B4.value,
        ],
      ),
    ],
  };
}
