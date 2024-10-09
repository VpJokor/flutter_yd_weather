import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';
import '../model/city_data.dart';
import '../model/weather_bg_model.dart';
import '../routers/fluro_navigator.dart';
import '../routers/routers.dart';
import '../utils/toast_utils.dart';

typedef OnWeatherCardSortChanged = void Function(
    List<int> currentWeatherCardSort);

typedef OnWeatherObservesCardSortChanged = void Function(
    List<int> currentWeatherCardSort, List<int> currentWeatherObservesCardSort);

typedef OnWeatherBgMapChanged = void Function(
    Map<String, List<WeatherBgModel>> weatherBgMap);

typedef OnWeatherBgChanged = void Function();

class MainProvider extends ChangeNotifier {
  final _cityDataBox = Hive.box<CityData>(Constants.cityDataBox);

  Box<CityData> get cityDataBox => _cityDataBox;

  CityData? _currentCityData;

  CityData? get currentCityData => _currentCityData;

  OnWeatherCardSortChanged? _onWeatherCardSortChanged;

  set onWeatherCardSortChanged(
      OnWeatherCardSortChanged? onWeatherCardSortChanged) {
    _onWeatherCardSortChanged = onWeatherCardSortChanged;
  }

  OnWeatherObservesCardSortChanged? _onWeatherObservesCardSortChanged;

  set onWeatherObservesCardSortChanged(
      OnWeatherObservesCardSortChanged? onWeatherObservesCardSortChanged) {
    _onWeatherObservesCardSortChanged = onWeatherObservesCardSortChanged;
  }

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
            Constants.currentWeatherCardSort, _currentWeatherCardSort)
        ?.then((success) {
      debugPrint("currentWeatherCardSort success = $success");
      if (success) {
        Commons.post((_) {
          _onWeatherCardSortChanged?.call(currentWeatherCardSort);
        });
      }
    });
  }

  List<String> _currentWeatherObservesCardSort = SpUtil.getStringList(
          Constants.currentWeatherObservesCardSort,
          defValue: Constants.defaultWeatherObservesCardSort) ??
      Constants.defaultWeatherObservesCardSort;

  List<int> get currentWeatherObservesCardSort =>
      _currentWeatherObservesCardSort.map((e) => int.parse(e)).toList();

  set currentWeatherObservesCardSort(List<int> currentWeatherObservesCardSort) {
    _currentWeatherObservesCardSort =
        currentWeatherObservesCardSort.map((e) => e.toString()).toList();
    SpUtil.putStringList(Constants.currentWeatherObservesCardSort,
            _currentWeatherObservesCardSort)
        ?.then((success) {
      debugPrint("currentWeatherObservesCardSort success = $success");
      if (success) {
        Commons.post((_) {
          _onWeatherObservesCardSortChanged?.call(
              currentWeatherCardSort, currentWeatherObservesCardSort);
        });
      }
    });
  }

  set currentCityData(CityData? cityData) {
    _currentCityData = cityData;
    if (cityData != null) {
      final isLocationCity = cityData.isLocationCity ?? false;
      SpUtil.putString(Constants.currentCityId,
          isLocationCity ? Constants.locationCityId : cityData.cityId ?? "");
    }
  }

  Future<void> updateCity(CityData? cityData) async {
    if (cityData == null) {
      Toast.show("数据异常，请稍后再试");
      return Future.value();
    }
    final isLocationCity = cityData.isLocationCity ?? false;
    await cityDataBox.put(
        isLocationCity ? Constants.locationCityId : cityData.cityId, cityData);
    currentCityData = cityData;
    return Future.value();
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

  @override
  void dispose() {
    debugPrint("MainProvider dispose");
    _onWeatherCardSortChanged = null;
    _onWeatherObservesCardSortChanged = null;
    super.dispose();
  }
}
