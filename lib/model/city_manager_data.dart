import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/model/city_data.dart';

class CityManagerData {
  final Key key;
  final CityData? cityData;

  CityManagerData(
    this.key,
    this.cityData,
  );
}
