import 'package:flutter/cupertino.dart';
import 'package:flutter_yd_weather/base/base_list_provider.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:sp_util/sp_util.dart';

import '../../model/city_manager_data.dart';
import '../../provider/main_provider.dart';
import '../../res/colours.dart';
import '../../utils/color_utils.dart';

class CityManagerProvider extends BaseListProvider<CityManagerData> {
  Color _titleColor = Colours.transparent;
  Color largeTitleColor = Colours.color333333;

  Color get titleColor => _titleColor;

  void changeAlpha(BuildContext context, double alpha) {
    _titleColor = ColorUtils.adjustAlpha(context.black, alpha);
    largeTitleColor = ColorUtils.adjustAlpha(context.black, 1 - alpha);
    notifyListeners();
  }

  void generate(MainProvider mainP) {
    final list = <CityManagerData>[];
    final currentCityIdList = SpUtil.getStringList(Constants.currentCityIdList) ?? [];
    Log.e("currentCityIdList = $currentCityIdList");
    currentCityIdList.forEachIndexed((cityId, index) {
      final cityData = mainP.cityDataBox.get(cityId);
      final findCityId = cityData?.cityId ?? "";
      if (findCityId.isNotNullOrEmpty()) {
        if (findCityId == Constants.locationCityId) {
          list.insert(0, CityManagerData(ValueKey(index), cityData));
        } else {
          list.add(CityManagerData(ValueKey(index), cityData));
        }
      }
    });
    replace(list, refresh: false);
  }

  void swap(int draggingIndex, int newPositionIndex, CityManagerData draggedItem) {
    removeAt(draggingIndex);
    insert(newPositionIndex, draggedItem);
    refresh();
    /*final cityIdList = list.map((element) => element.cityData?.cityId ?? "").toList();
    if (cityIdList.contains(Constants.locationCityId)) {
      SpUtil.putStringList(Constants.currentCityIdList, cityIdList);
    } else {
      final newCityIdList = [Constants.locationCityId];
      newCityIdList.addAll(cityIdList);
      SpUtil.putStringList(Constants.currentCityIdList, newCityIdList);
    }*/
  }
}
