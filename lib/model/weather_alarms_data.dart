import 'package:json_annotation/json_annotation.dart';

part 'weather_alarms_data.g.dart';

@JsonSerializable()
class WeatherAlarmsData {
  @JsonKey(name: "short_title")
  String? title;
  String? desc;
  @JsonKey(name: "pub_time")
  String? pubTime;

  WeatherAlarmsData(
    this.title,
    this.desc,
    this.pubTime,
  );

  factory WeatherAlarmsData.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlarmsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlarmsDataToJson(this);
}
