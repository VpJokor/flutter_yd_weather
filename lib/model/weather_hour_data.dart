import 'package:json_annotation/json_annotation.dart';

part 'weather_hour_data.g.dart';

@JsonSerializable()
class WeatherHourData {
  String? time;
  @JsonKey(name: "shidu")
  String? shiDu;
  int? type;
  @JsonKey(name: "type_desc")
  String? typeDesc;
  String? wd;
  String? wp;

  WeatherHourData(
    this.time,
    this.shiDu,
    this.type,
    this.typeDesc,
    this.wd,
    this.wp,
  );

  factory WeatherHourData.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherHourDataToJson(this);
}
