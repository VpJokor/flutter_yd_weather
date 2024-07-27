import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/simple_weather_data.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_data.g.dart';

@HiveType(typeId: Constants.cityDataTypeId)
@JsonSerializable()
class CityData {
  @HiveField(0)
  @JsonKey(name: "city_level_name")
  String? cityLevelName;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? country;
  @HiveField(3)
  String? upper;
  @HiveField(4)
  String? prov;
  @HiveField(5)
  int? type;
  @HiveField(6)
  @JsonKey(name: "prov_en")
  String? provEn;
  @HiveField(7)
  @JsonKey(name: "cityid")
  String? cityId;
  @HiveField(8)
  @JsonKey(name: "city_level_id")
  String? cityLevelId;
  @HiveField(9)
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isLocationCity;
  @HiveField(10)
  @JsonKey(includeFromJson: false, includeToJson: false)
  SimpleWeatherData? weatherData;

  CityData(
    this.cityLevelName,
    this.name,
    this.country,
    this.upper,
    this.prov,
    this.type,
    this.provEn,
    this.cityId,
    this.cityLevelId,
  );

  CityData.locationCity() {
    isLocationCity = true;
  }

  factory CityData.fromJson(Map<String, dynamic> json) =>
      _$CityDataFromJson(json);

  Map<String, dynamic> toJson() => _$CityDataToJson(this);

  @override
  bool operator ==(Object other) => other is CityData && cityId == other.cityId;

  @override
  int get hashCode => cityId.hashCode;

  @override
  String toString() {
    return "${toJson()} isLocationCity = $isLocationCity";
  }
}
