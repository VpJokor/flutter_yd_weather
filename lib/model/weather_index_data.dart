import 'package:flutter_yd_weather/model/weather_index_ext_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_index_data.g.dart';

@JsonSerializable()
class WeatherIndexData {
  WeatherIndexExtData? ext;
  String? name;
  String? value;
  String? desc;

  WeatherIndexData(
    this.ext,
    this.name,
    this.value,
    this.desc,
  );

  factory WeatherIndexData.fromJson(Map<String, dynamic> json) =>
      _$WeatherIndexDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherIndexDataToJson(this);

  @override
  bool operator ==(Object other) =>
      other is WeatherIndexData && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return "${toJson()}";
  }
}
