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
  @JsonKey(name: "co_level")
  int? coLevel;
  String? mp;
  int? no2;
  @JsonKey(name: "no2_level")
  int? no2Level;
  int? o3;
  @JsonKey(name: "o3_level")
  int? o3Level;
  int? pm10;
  @JsonKey(name: "pm10_level")
  int? pm10Level;
  int? pm25;
  @JsonKey(name: "pm25_level")
  int? pm25Level;
  String? quality;
  int? so2;
  @JsonKey(name: "so2_level")
  int? so2Level;

  WeatherEnvData(
      this.aqi,
      this.aqiLevel,
      this.aqiLevelName,
      this.co,
      this.coLevel,
      this.mp,
      this.no2,
      this.no2Level,
      this.o3,
      this.o3Level,
      this.pm10,
      this.pm10Level,
      this.pm25,
      this.pm25Level,
      this.quality,
      this.so2,
      this.so2Level,
      );

  factory WeatherEnvData.fromJson(Map<String, dynamic> json) =>
      _$WeatherEnvDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherEnvDataToJson(this);
}