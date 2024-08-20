import 'package:json_annotation/json_annotation.dart';

part 'weather_forecast40_data.g.dart';

@JsonSerializable()
class WeatherForecast40Data {
  @JsonKey(name: "average_temp")
  int? averageTemp;
  @JsonKey(name: "up_days")
  int? upDays;
  @JsonKey(name: "down_days")
  int? downDays;
  @JsonKey(name: "rain_days")
  int? rainDays;

  WeatherForecast40Data(
    this.averageTemp,
    this.upDays,
    this.downDays,
    this.rainDays,
  );

  factory WeatherForecast40Data.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecast40DataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecast40DataToJson(this);
}
