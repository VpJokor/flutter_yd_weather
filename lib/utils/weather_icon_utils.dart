class WeatherIconUtils {
  static String getWeatherIconByType(int type, bool isNight) {
    String weatherIcon = "fifteen_weather_no";
    if (!isNight) {
      switch (type) {
        case 1:
          // 晴天
          weatherIcon = "fifteen_weather_sunny";
          break;
        case 2:
          // 多云
          weatherIcon = "fifteen_weather_sunny";
          break;
        case 3:
          // 阵雨
          weatherIcon = "fifteen_weather_sunny";
          break;
        case 4:
          // 雷阵雨
          weatherIcon = "fifteen_weather_sunny";
          break;
      }
    } else {
      switch (type) {
        case 1:
          // 晴天
          weatherIcon = "fifteen_weather_sunny_n";
          break;
        case 2:
          // 多云
          weatherIcon = "fifteen_weather_mostlycloudy_n";
          break;
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
    switch (type) {
      case 8: // 小雨
      case 9: // 小到中雨
        weatherIcon = "fifteen_weather_lightrain";
        break;
      case 10: // 中雨
      case 11: // 大雨
      case 13: // 大暴雨
        weatherIcon = "fifteen_weather_rain";
        break;
      case 34: // 阴
        weatherIcon = "fifteen_weather_cloudy";
        break;
    }
    return weatherIcon;
  }
}
