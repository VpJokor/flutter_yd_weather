import 'dart:ui';

import 'package:flutter_yd_weather/utils/commons_ext.dart';
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

  @override
  bool operator ==(Object other) {
    if (other is! WeatherBgModel) {
      return false;
    }
    final colors = this.colors;
    final otherColors = other.colors;
    final nightColors = this.nightColors ?? this.colors;
    final otherNightColors = other.nightColors ?? other.colors;
    if (colors == null ||
        otherColors == null ||
        nightColors == null ||
        otherNightColors == null) {
      return false;
    }
    if (colors.length >= 2 &&
        otherColors.length >= 2 &&
        nightColors.length >= 2 &&
        otherNightColors.length >= 2) {
      return colors[0] == otherColors[0] &&
          colors[1] == otherColors[1] &&
          nightColors[0] == otherNightColors[0] &&
          nightColors[1] == otherNightColors[1];
    }
    return false;
  }

  @override
  int get hashCode {
    final colors = this.colors;
    final nightColors = this.nightColors ?? this.colors;
    var result = 17;
    result = 37 * result + colors.hashCode;
    result = 37 * result + nightColors.hashCode;
    return result;
  }

  @override
  String toString() {
    return "${toJson()}";
  }
}
