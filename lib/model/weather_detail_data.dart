import 'package:flutter_yd_weather/model/weather_info_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_detail_data.g.dart';

@JsonSerializable()
class WeatherDetailData {
  String? date;
  String? sunrise;
  String? sunset;
  int? type;
  int? high;
  int? low;
  String? wthr;
  String? wd;
  String? wp;
  WeatherInfoData? day;
  WeatherInfoData? night;

  WeatherDetailData(
    this.date,
    this.sunrise,
    this.sunset,
    this.type,
    this.high,
    this.low,
    this.wthr,
    this.wd,
    this.wp,
    this.day,
    this.night,
  );

  factory WeatherDetailData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDetailDataToJson(this);
}