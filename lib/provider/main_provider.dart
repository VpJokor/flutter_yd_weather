import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  set currentCityData(CityData? cityData) {
    _currentCityData = cityData;
    notifyListeners();
  }

  void addCity(BuildContext context, bool hasAdded, CityData? cityData) {
    if (hasAdded) {
      Toast.show("该城市已经添加过了哦");
    } else {
      cityDataBox.put(cityData?.cityId, cityData!).then((_) {
        currentCityData = cityData;
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
