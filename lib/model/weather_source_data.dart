import 'package:json_annotation/json_annotation.dart';

part 'weather_source_data.g.dart';

@JsonSerializable()
class WeatherSourceData {
  String? title;

  WeatherSourceData(
      this.title,
      );

  factory WeatherSourceData.fromJson(Map<String, dynamic> json) =>
      _$WeatherSourceDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherSourceDataToJson(this);
}