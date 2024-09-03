import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'weather_bg_model.g.dart';

@JsonSerializable()
class WeatherBgModel {
  bool? supportEdit;
  List<int>? colors;
  List<int>? nightColors;
  bool? isSelected;

  WeatherBgModel({
    this.supportEdit = false,
    this.colors,
    this.nightColors,
    this.isSelected = false,
  });

  factory WeatherBgModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherBgModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherBgModelToJson(this);
}
