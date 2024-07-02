import 'package:flutter_yd_weather/model/weather_detail_data.dart';
import 'package:flutter_yd_weather/model/weather_env_data.dart';
import 'package:flutter_yd_weather/model/weather_forecast40_data.dart';
import 'package:flutter_yd_weather/model/weather_hour_data.dart';
import 'package:flutter_yd_weather/model/weather_index_data.dart';
import 'package:flutter_yd_weather/model/weather_meta_data.dart';
import 'package:flutter_yd_weather/model/weather_source_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  @JsonKey(name: "future_remind")
  String? futureRemind;
  List<WeatherDetailData>? forecast15;
  @JsonKey(name: "hourfc")
  List<WeatherHourData>? hourFc;
  WeatherMetaData? meta;
  WeatherSourceData? source;
  @JsonKey(name: "forecast40_v2")
  WeatherForecast40Data? forecast40Data;
  List<WeatherDetailData>? forecast40;
  WeatherEnvData? evn;
  List<WeatherIndexData>? indexes;

  WeatherData(
    this.futureRemind,
    this.forecast15,
    this.hourFc,
    this.meta,
    this.source,
    this.forecast40Data,
    this.forecast40,
    this.evn,
    this.indexes,
  );

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
