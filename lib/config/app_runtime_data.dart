import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';

import '../utils/log.dart';

class AppRuntimeData {
  factory AppRuntimeData() => _singleton;

  AppRuntimeData._internal();

  static final AppRuntimeData _singleton = AppRuntimeData._internal();

  static AppRuntimeData get instance => AppRuntimeData();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  PackageInfo getPackageInfo() => _packageInfo;

  void updatePackageInfo(PackageInfo? packageInfo) {
    if (packageInfo == null) return;
    Log.e("packageInfo = $packageInfo");
    _packageInfo = packageInfo;
  }

  final _weatherDataMap = <String, WeatherData?>{};

  void saveWeatherData(String saveKey, WeatherData? weatherData) {
    if (weatherData != null) {
      _weatherDataMap[saveKey] = weatherData;
      SpUtil.putObject(saveKey, weatherData);
    } else {
      _weatherDataMap.remove(saveKey);
      SpUtil.putString(saveKey, "");
    }
  }

  WeatherData? getWeatherData(String key) {
    final weatherData = _weatherDataMap[key];
    if (weatherData != null) {
      return weatherData;
    }
    return SpUtil.getObj(
      key,
      (map) => WeatherData.fromJson(map as Map<String, dynamic>),
    );
  }
}
