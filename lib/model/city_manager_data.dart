import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_yd_weather/model/city_data.dart';

class CityManagerData {
  final Key key;
  CityData? cityData;
  SlidableController? slidableController;
  bool removed;

  CityManagerData(
    this.key,
    this.cityData, {
    this.slidableController,
    this.removed = false,
  });
}
