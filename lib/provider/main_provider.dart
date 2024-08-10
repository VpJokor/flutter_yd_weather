import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:hive/hive.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';
import '../model/city_data.dart';
import '../routers/fluro_navigator.dart';
import '../routers/routers.dart';
import '../utils/toast_utils.dart';

class MainProvider extends ChangeNotifier {
  final _cityDataBox = Hive.box<CityData>(Constants.cityDataBox);

  Box<CityData> get cityDataBox => _cityDataBox;

  CityData? _currentCityData;

  CityData? get currentCityData => _currentCityData;

  List<String> _currentWeatherCardSort = SpUtil.getStringList(
          Constants.currentWeatherCardSort,
          defValue: Constants.defaultWeatherCardSort) ??
      Constants.defaultWeatherCardSort;

  List<int> get currentWeatherCardSort =>
      _currentWeatherCardSort.map((e) => int.parse(e)).toList();

  set currentWeatherCardSort(List<int> currentWeatherCardSort) {
    _currentWeatherCardSort =
        currentWeatherCardSort.map((e) => e.toString()).toList();
    SpUtil.putStringList(
        Constants.currentWeatherCardSort, _currentWeatherCardSort);
  }

  set currentCityData(CityData? cityData) {
    _currentCityData = cityData;
    if (cityData != null) {
      final isLocationCity = cityData.isLocationCity ?? false;
      SpUtil.putString(Constants.currentCityId,
          isLocationCity ? Constants.locationCityId : cityData.cityId ?? "");
    }
  }

  void addCity(BuildContext context, bool hasAdded, CityData? cityData) {
    if (cityData == null) {
      Toast.show("数据异常，请稍后再试");
      return;
    }
    if (hasAdded) {
      Toast.show("该城市已经添加过了哦");
    } else {
      final isLocationCity = cityData.isLocationCity ?? false;
      cityDataBox
          .put(isLocationCity ? Constants.locationCityId : cityData.cityId,
              cityData)
          .then((_) {
        currentCityData = cityData;
        final currentCityIdList =
            SpUtil.getStringList(Constants.currentCityIdList, defValue: []) ??
                [];
        currentCityIdList.add(isLocationCity
            ? Constants.locationCityId
            : (cityData.cityId ?? ""));
        SpUtil.putStringList(Constants.currentCityIdList, currentCityIdList);
        eventBus.fire(RefreshWeatherDataEvent(isAdd: true));
        if (Navigator.canPop(context)) {
          NavigatorUtils.goBackUntil(context, Routes.main);
        } else {
          NavigatorUtils.push(
            context,
            Routes.main,
            replace: true,
            transition: TransitionType.fadeIn,
          );
        }
      });
    }
  }
}
