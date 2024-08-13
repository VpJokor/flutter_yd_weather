import 'package:json_annotation/json_annotation.dart';

part 'weather_alarms_data.g.dart';

@JsonSerializable()
class WeatherAlarmsData {
  String? degree;
  @JsonKey(name: "short_title")
  String? title;
  String? desc;
  String? details;
  @JsonKey(name: "pub_time")
  String? pubTime;
  @JsonKey(name: "icon_big")
  String? icon;

  WeatherAlarmsData(
    this.degree,
    this.title,
    this.desc,
    this.details,
    this.pubTime,
    this.icon,
  );

  factory WeatherAlarmsData.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlarmsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlarmsDataToJson(this);
}
