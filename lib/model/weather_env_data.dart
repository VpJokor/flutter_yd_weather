import 'package:json_annotation/json_annotation.dart';

part 'weather_env_data.g.dart';

@JsonSerializable()
class WeatherEnvData {
  int? aqi;
  @JsonKey(name: "aqi_level")
  int? aqiLevel;
  @JsonKey(name: "aqi_level_name")
  String? aqiLevelName;
  int? co;
  String? mp;
  int? no2;
  int? o3;
  int? pm10;
  int? pm25;
  String? quality;
  int? so2;

  WeatherEnvData(
      this.aqi,
      this.aqiLevel,
      this.aqiLevelName,
      this.co,
      this.mp,
      this.no2,
      this.o3,
      this.pm10,
      this.pm25,
      this.quality,
      this.so2,
      );

  factory WeatherEnvData.fromJson(Map<String, dynamic> json) =>
      _$WeatherEnvDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherEnvDataToJson(this);
}