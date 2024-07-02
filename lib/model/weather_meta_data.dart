import 'package:json_annotation/json_annotation.dart';

part 'weather_meta_data.g.dart';

@JsonSerializable()
class WeatherMetaData {
  @JsonKey(name: "citykey")
  String? cityKey;
  String? city;
  @JsonKey(name: "html_url")
  String? htmlUrl;
  String? upper;

  WeatherMetaData(
      this.cityKey,
      this.city,
      this.htmlUrl,
      this.upper,
      );

  factory WeatherMetaData.fromJson(Map<String, dynamic> json) =>
      _$WeatherMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherMetaDataToJson(this);
}