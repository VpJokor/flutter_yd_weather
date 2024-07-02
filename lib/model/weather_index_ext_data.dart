import 'package:json_annotation/json_annotation.dart';

part 'weather_index_ext_data.g.dart';

@JsonSerializable()
class WeatherIndexExtData {
  String? icon;
  String? statsKey;

  WeatherIndexExtData(
    this.icon,
    this.statsKey,
  );

  factory WeatherIndexExtData.fromJson(Map<String, dynamic> json) =>
      _$WeatherIndexExtDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherIndexExtDataToJson(this);
}
