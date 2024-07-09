import 'package:json_annotation/json_annotation.dart';

part 'weather_alarms_data.g.dart';

@JsonSerializable()
class WeatherAlarmsData {
  String? degree;
  @JsonKey(name: "short_title")
  String? title;
  String? desc;
  String? details;

  WeatherAlarmsData(
      this.degree,
      this.title,
      this.desc,
      this.details,
      );

  factory WeatherAlarmsData.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlarmsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlarmsDataToJson(this);
}