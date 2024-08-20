import 'package:json_annotation/json_annotation.dart';

part 'weather_hour_data.g.dart';

@JsonSerializable()
class WeatherHourData {
  String? time;
  @JsonKey(name: "shidu")
  String? shiDu;
  int? type;
  @JsonKey(name: "third_type")
  String? weatherType;
  @JsonKey(name: "type_desc")
  String? typeDesc;
  String? wd;
  String? wp;
  @JsonKey(name: "wthr")
  int? temp;

  WeatherHourData(
    this.time,
    this.shiDu,
    this.type,
    this.weatherType,
    this.typeDesc,
    this.wd,
    this.wp,
    this.temp,
  );

  factory WeatherHourData.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherHourDataToJson(this);
}
