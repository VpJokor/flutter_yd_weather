class WeatherIconUtils {
  static String getWeatherIconByType(
    int type,
    String weatherType,
    bool isNight,
  ) {
    String weatherIcon = "";
    switch (weatherType) {
      case "CLEAR_DAY":
      case "CLEAR_NIGHT":
        // 晴天
        weatherIcon =
            isNight ? "fifteen_weather_sunny_n" : "fifteen_weather_sunny";
        break;
      case "PARTLY_CLOUDY_DAY":
      case "PARTLY_CLOUDY_NIGHT":
        // 多云
        weatherIcon = isNight
            ? "fifteen_weather_mostlycloudy_n"
            : "fifteen_weather_mostlycloudy";
        break;
      case "CLOUDY":
        // 阴
        weatherIcon = "fifteen_weather_cloudy";
        break;
      case "LIGHT_HAZE":
      case "MODERATE_HAZE":
      case "HEAVY_HAZE":
        // 轻度雾霾 中度雾霾 重度雾霾
        weatherIcon = "weather_icon_53";
        break;
      case "LIGHT_RAIN":
      case "MODERATE_RAIN":
        // 小雨 中雨
        weatherIcon = "fifteen_weather_lightrain";
        break;
      case "HEAVY_RAIN":
      case "STORM_RAIN":
        // 大雨 暴雨
        weatherIcon = "fifteen_weather_rain";
        break;
      case "FOG":
        // 雾
        weatherIcon = "weather_icon_18";
        break;
      case "LIGHT_SNOW":
        // 小雪
        weatherIcon = "weather_icon_14";
        break;
      case "MODERATE_SNOW":
        // 中雪
        weatherIcon = "weather_icon_15";
        break;
      case "HEAVY_SNOW":
        // 大雪
        weatherIcon = "weather_icon_16";
        break;
      case "STORM_SNOW":
        // 暴雪
        weatherIcon = "weather_icon_17";
        break;
      case "DUST":
        // 浮尘
        weatherIcon = "weather_icon_29";
        break;
      case "SAND":
        // 沙尘
        weatherIcon = "weather_icon_30";
        break;
      case "WIND":
        // 大风
        weatherIcon = "weather_icon_wind";
        break;
    }
    if (weatherIcon.isEmpty) {
      if (!isNight) {
        switch (type) {
          case 3:
            // 阵雨
            weatherIcon = "fifteen_weather_chancerain";
            break;
          case 4:
            // 雷阵雨
            weatherIcon = "fifteen_weather_chancestorm";
            break;
        }
      } else {
        switch (type) {
          case 3:
            // 阵雨
            weatherIcon = "fifteen_weather_chancerain_n";
            break;
          case 4:
            // 雷阵雨
            weatherIcon = "fifteen_weather_chancestorm_n";
            break;
        }
      }
    }
    if (weatherIcon.isEmpty) {
      weatherIcon = "fifteen_weather_no";
    }
    return weatherIcon;
  }
}
