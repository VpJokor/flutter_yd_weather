import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sp_util/sp_util.dart';

import '../model/weather_bg_model.dart';
import '../provider/main_provider.dart';
import '../utils/color_utils.dart';
import '../utils/commons.dart';
import '../utils/log.dart';
import '../utils/toast_utils.dart';
import 'constants.dart';

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

  OnWeatherBgMapChanged? _onWeatherBgMapChanged;

  OnWeatherBgChanged? _onWeatherBgChanged;

  set onWeatherBgMapChanged(OnWeatherBgMapChanged? onWeatherBgMapChanged) {
    _onWeatherBgMapChanged = onWeatherBgMapChanged;
  }

  set onWeatherBgChanged(OnWeatherBgChanged? onWeatherBgChanged) {
    _onWeatherBgChanged = onWeatherBgChanged;
  }

  final Map<String, List<WeatherBgModel>> _weatherBgMap = {};

  bool isDailyWeatherExpand = false;

  String currentDailyWeatherType = SpUtil.getString(
          Constants.currentDailyWeatherType,
          defValue: Constants.listDailyWeather) ??
      Constants.listDailyWeather;

  Map<String, List<WeatherBgModel>> getWeatherBgMap() {
    if (_weatherBgMap.isEmpty) {
      final currentWeatherBgMap = SpUtil.getObj(
        Constants.currentWeatherBgMap,
        (v) => v.map(
          (e1, e2) {
            return MapEntry(
                e1.toString(),
                (e2 as List<dynamic>)
                    .map((e) => WeatherBgModel.fromJson(e))
                    .toList());
          },
        ),
      );
      if (currentWeatherBgMap == null || currentWeatherBgMap.isEmpty) {
        SpUtil.putObject(
            Constants.currentWeatherBgMap, Constants.defaultWeatherBgMap);
        _weatherBgMap.addAll({...Constants.defaultWeatherBgMap});
      } else {
        _weatherBgMap.addAll({...currentWeatherBgMap});
      }
    }
    return _weatherBgMap;
  }

  void addWeatherBg(String weatherType, WeatherBgModel weatherBgModel,
      {WeatherBgModel? editWeatherBgModel, VoidCallback? callback}) {
    final currentWeatherBgMap = getWeatherBgMap();
    final result = currentWeatherBgMap[weatherType]?.where((e) {
      final addColor1 = weatherBgModel.colors?.getOrNull(0);
      final addColor2 = weatherBgModel.colors?.getOrNull(1);
      final addNightColor1 =
          (weatherBgModel.nightColors ?? weatherBgModel.colors)?.getOrNull(0);
      final addNightColor2 =
          (weatherBgModel.nightColors ?? weatherBgModel.colors)?.getOrNull(1);
      final color1 = e.colors?.getOrNull(0);
      final color2 = e.colors?.getOrNull(1);
      final nightColor1 = (e.nightColors ?? e.colors)?.getOrNull(0);
      final nightColor2 = (e.nightColors ?? e.colors)?.getOrNull(1);
      final similarity1 =
          ColorUtils.calSimilarity(addColor1.getColor(), color1.getColor());
      final similarity2 =
          ColorUtils.calSimilarity(addColor2.getColor(), color2.getColor());
      final nightSimilarity1 = ColorUtils.calSimilarity(
          addNightColor1.getColor(), nightColor1.getColor());
      final nightSimilarity2 = ColorUtils.calSimilarity(
          addNightColor2.getColor(), nightColor2.getColor());
      return (similarity1 > 0.9 && similarity2 > 0.9) &&
          (nightSimilarity1 > 0.9 && nightSimilarity2 > 0.9);
    });
    if (result != null && result.isNotEmpty) {
      Toast.show("天气背景相似度过高，请重新编辑！");
      return;
    }
    final list = currentWeatherBgMap[weatherType] ?? [];
    final index =
        editWeatherBgModel == null ? -1 : list.indexOf(editWeatherBgModel);
    if (index >= 0) {
      list[index] = weatherBgModel;
    } else {
      list.add(weatherBgModel);
    }
    currentWeatherBgMap[weatherType] = list;
    SpUtil.putObject(Constants.currentWeatherBgMap, currentWeatherBgMap)
        ?.then((success) {
      debugPrint("addWeatherBg success = $success");
      if (success) {
        Commons.post((_) {
          _onWeatherBgMapChanged?.call(getWeatherBgMap());
          if (editWeatherBgModel != null) {
            _onWeatherBgChanged?.call();
          }
          callback?.call();
        });
      }
    });
  }

  void removeAllWeatherBg({VoidCallback? callback}) {
    SpUtil.putObject(
            Constants.currentWeatherBgMap, Constants.defaultWeatherBgMap)
        ?.then((success) {
      debugPrint("removeAllWeatherBg success = $success");
      if (success) {
        _weatherBgMap.clear();
        Commons.post((_) {
          _onWeatherBgMapChanged?.call(getWeatherBgMap());
          _onWeatherBgChanged?.call();
          callback?.call();
        });
      }
    });
  }

  void removeWeatherBg(String weatherType, WeatherBgModel weatherBgModel) {
    final currentWeatherBgMap = getWeatherBgMap();
    currentWeatherBgMap[weatherType]?.remove(weatherBgModel);
    if (weatherBgModel.isSelected ?? false) {
      currentWeatherBgMap[weatherType]?.getOrNull(0)?.isSelected = true;
    }
    SpUtil.putObject(Constants.currentWeatherBgMap, currentWeatherBgMap)
        ?.then((success) {
      debugPrint("removeWeatherBg success = $success");
      if (success) {
        Commons.post((_) {
          _onWeatherBgMapChanged?.call(getWeatherBgMap());
          if (weatherBgModel.isSelected ?? false) {
            _onWeatherBgChanged?.call();
          }
        });
      }
    });
  }

  void setCurrentWeatherBg(String weatherType, WeatherBgModel weatherBgModel) {
    final currentWeatherBgMap = getWeatherBgMap();
    currentWeatherBgMap[weatherType]
        ?.forEach((e) => e.isSelected = e == weatherBgModel);
    SpUtil.putObject(Constants.currentWeatherBgMap, currentWeatherBgMap)
        ?.then((success) {
      debugPrint("setCurrentWeatherBg success = $success");
      if (success) {
        Commons.post((_) {
          _onWeatherBgMapChanged?.call(getWeatherBgMap());
          _onWeatherBgChanged?.call();
        });
      }
    });
  }

  void dispose() {
    _onWeatherBgChanged = null;
  }
}
