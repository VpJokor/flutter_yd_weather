import 'package:flutter/material.dart';

import '../res/colours.dart';

class WeatherBgUtils {
  static LinearGradient getWeatherBg(String type, bool isNight) {
    Color color1 = isNight ? Colours.color1A1B30 : Colours.colorF47359;
    Color color2 = isNight ? Colours.color232941 : Colours.colorF49670;
    Color color3 = isNight ? Colours.color2E3C54 : Colours.colorF1AB80;
    switch (type) {
      case "CLEAR":
      case "CLEAR_DAY":
      case "CLEAR_NIGHT":
        // 晴天
        color1 = isNight ? Colours.color1A1B30 : Colours.colorF47359;
        color2 = isNight ? Colours.color232941 : Colours.colorF49670;
        color3 = isNight ? Colours.color2E3C54 : Colours.colorF1AB80;
        break;
      case "PARTLY_CLOUDY":
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
      case "MODERATE_HAZE":
        // 轻度雾霾 中度雾霾
        color1 = Colours.colorBC8E3E;
        color2 = Colours.colorCFA451;
        color3 = Colours.colorE5BB62;
        break;
      case "HEAVY_HAZE":
        // 重度雾霾
        color1 = Colours.colorB77B32;
        color2 = Colours.colorD79B4D;
        color3 = Colours.colorF7BA66;
        break;
      case "LIGHT_RAIN":
        // 小雨
        color1 = isNight ? Colours.color171A2A : Colours.color5E738D;
        color2 = isNight ? Colours.color21273C : Colours.color7D849C;
        color3 = isNight ? Colours.color3C4354 : Colours.color8F9AAD;
        break;
      case "MODERATE_RAIN":
      case "HEAVY_RAIN":
      case "STORM_RAIN":
        // 中雨 大雨 暴雨
        color1 = Colours.color171A2A;
        color2 = Colours.color21273C;
        color3 = Colours.color3C4354;
        break;
      case "FOG":
      case "LIGHT_SNOW":
      case "MODERATE_SNOW":
      case "HEAVY_SNOW":
      case "STORM_SNOW":
        // 雾 小雪 中雪 大雪 暴雪
        color1 = Colours.colorABB7C4;
        color2 = Colours.colorAEC7D7;
        color3 = Colours.colorB6C7CD;
        break;
      case "DUST":
      case "SAND":
        // 浮尘 沙尘
        color1 = Colours.colorF7CB6A;
        color2 = Colours.colorFBB777;
        color3 = Colours.colorFDA085;
        break;
      case "WIND":
        // 大风
        color1 = Colours.color4776B0;
        color2 = Colours.color8A8AB1;
        color3 = Colours.colorE9A4B4;
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
