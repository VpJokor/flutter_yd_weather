import 'package:flutter_yd_weather/base/base_list_view.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/location_data.dart';

abstract class SelectCityView implements BaseListView<CityData> {
  void locationSuccess(LocationData? locationData);
}