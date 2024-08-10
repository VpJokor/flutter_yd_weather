import 'package:flutter/cupertino.dart';
import 'package:flutter_yd_weather/base/base_list_provider.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:sp_util/sp_util.dart';

import '../../model/city_manager_data.dart';
import '../../provider/main_provider.dart';

class CityManagerProvider extends BaseListProvider<CityManagerData> {
  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  set isEditMode(bool isEditMode) {
    _isEditMode = isEditMode;
    if (!_isEditMode) {
      clearSelected();
    } else {
      notifyListeners();
    }
  }

  final _selectedList = <CityManagerData>[];

  List<CityManagerData> get selectedList => _selectedList;

  bool get isSelectedAll =>
      list.singleOrNull((e) => e.cityData?.isLocationCity == true) != null
          ? _selectedList.length == list.length - 1
          : _selectedList.length == list.length;

  void selected(CityManagerData data) {
    if (_selectedList.contains(data)) {
      _selectedList.remove(data);
    } else {
      _selectedList.add(data);
    }
    notifyListeners();
  }

  void selectedAll() {
    _selectedList.clear();
    _selectedList.addAll(
        list.where((e) => e.cityData?.isLocationCity != true).toList());
    notifyListeners();
  }

  void clearSelected() {
    _selectedList.clear();
    notifyListeners();
  }

  void generate(MainProvider mainP) {
    final list = <CityManagerData>[];
    final currentCityIdList =
        SpUtil.getStringList(Constants.currentCityIdList) ?? [];
    Log.e("currentCityIdList = $currentCityIdList");
    currentCityIdList.forEachIndexed((cityId, index) {
      final cityData = mainP.cityDataBox.get(cityId);
      final findCityId = cityData?.cityId ?? "";
      if (findCityId.isNotNullOrEmpty()) {
        if (cityId == Constants.locationCityId) {
          list.insert(
              0, CityManagerData(ValueKey("$index-$findCityId}"), cityData));
        } else {
          list.add(CityManagerData(ValueKey("$index-$findCityId}"), cityData));
        }
      }
    });
    replace(list, refresh: false);
  }

  void swap(
      int draggingIndex, int newPositionIndex, CityManagerData draggedItem) {
    removeAt(draggingIndex, refresh: false);
    insert(newPositionIndex, draggedItem, refresh: false);
    refresh();
  }
}
