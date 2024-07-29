import 'package:flutter/material.dart';

import '../res/colours.dart';

// 浮尘	DUST	AQI > 150, PM10 > 150，湿度 < 30%，风速 < 6 m/s
// 沙尘	SAND	AQI > 150, PM10> 150，湿度 < 30%，风速 > 6 m/s
// 大风	WIND
class WeatherBgUtils {
  static LinearGradient getWeatherBg(String type, bool isNight) {
    Color color1 = Colours.colorF47359;
    Color color2 = Colours.colorF49670;
    Color color3 = Colours.colorF1AB80;
    switch (type) {
      case "CLEAR_DAY":
      case "CLEAR_NIGHT":
        // 晴天
        color1 = isNight ? Colours.color1A1B30 : Colours.colorF47359;
        color2 = isNight ? Colours.color232941 : Colours.colorF49670;
        color3 = isNight ? Colours.color2E3C54 : Colours.colorF1AB80;
        break;
      case "PARTLY_CLOUDY_DAY":
      case "PARTLY_CLOUDY_NIGHT":
        // 多云
        color1 = isNight ? Colours.color2E336C : Colours.colorABB7C4;
        color2 = isNight ? Colours.color414378 : Colours.colorAEC7D7;
        color3 = isNight ? Colours.color64648D : Colours.colorB6C7CD;
        break;
      case "CLOUDY":
        // 阴
        color1 = isNight ? Colours.color1E2232 : Colours.color58677F;
        color2 = isNight ? Colours.color1D2637 : Colours.color6B7B90;
        color3 = isNight ? Colours.color354359 : Colours.color828D9E;
        break;
      case "LIGHT_HAZE":
        // 轻度雾霾
        break;
      case "MODERATE_HAZE":
        // 中度雾霾
        break;
      case "HEAVY_HAZE":
        // 重度雾霾
        break;
      case "LIGHT_RAIN":
        // 小雨
        break;
      case "MODERATE_RAIN":
        // 中雨
        break;
      case "HEAVY_RAIN":
        // 大雨
        break;
      case "STORM_RAIN":
        // 暴雨
        break;
      case "FOG":
        // 雾
        break;
      case "LIGHT_SNOW":
        // 小雪
        break;
      case "MODERATE_SNOW":
        // 中雪
        break;
      case "HEAVY_SNOW":
        // 大雪
        break;
      case "STORM_SNOW":
        // 暴雪
        break;
      case "DUST":
        // 浮尘
        break;
      case "SAND":
        // 沙尘
        break;
      case "WIND":
        // 大风
        break;
    }
    return LinearGradient(
      colors: [
        color1,
        color2,
        color3,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
