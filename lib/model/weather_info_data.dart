import 'package:json_annotation/json_annotation.dart';

part 'weather_info_data.g.dart';

@JsonSerializable()
class WeatherInfoData {
  String? bgPic;
  String? smPic;
  String? wthr;
  String? wd;
  String? wp;
  int? type;
  String? notice;

  WeatherInfoData(
    this.bgPic,
    this.smPic,
    this.wthr,
    this.wd,
    this.wp,
    this.type,
    this.notice,
  );

  factory WeatherInfoData.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoDataToJson(this);
}
