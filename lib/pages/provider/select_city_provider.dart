import 'package:flutter_yd_weather/base/base_list_provider.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/location_data.dart';

import '../../model/select_city_data.dart';

class SelectCityProvider extends BaseListProvider<CityData> {
  SelectCityData? _selectCityData;

  SelectCityData? get selectCityData => _selectCityData;

  set selectCityData(SelectCityData? selectCityData) {
    _selectCityData = selectCityData;
    notifyListeners();
  }

  /// 0-定位中
  /// 1-定位结束
  int _locationStatus = 0;

  int get locationStatus => _locationStatus;

  LocationData? _locationData;

  LocationData? get locationData => _locationData;

  void setLocationData(LocationData? locationData, int locationStatus) {
    _locationData = locationData;
    _locationStatus = locationStatus;
    notifyListeners();
  }

  List<CityData>? _searchResult;

  List<CityData>? get searchResult => _searchResult;

  set searchResult(List<CityData>? result) {
    _searchResult = result;
    notifyListeners();
  }
}
