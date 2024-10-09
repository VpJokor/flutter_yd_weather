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
  String? street;
  @HiveField(3)
  String? country;
  @HiveField(4)
  String? upper;
  @HiveField(5)
  String? prov;
  @HiveField(6)
  int? type;
  @HiveField(7)
  @JsonKey(name: "prov_en")
  String? provEn;
  @HiveField(8)
  @JsonKey(name: "cityid")
  String? cityId;
  @HiveField(9)
  @JsonKey(name: "city_level_id")
  String? cityLevelId;
  @HiveField(10)
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isLocationCity;
  @HiveField(11)
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
  bool operator ==(Object other) =>
      other is CityData &&
      cityId == other.cityId &&
      name == other.name &&
      street == other.street;

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + cityId.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + street.hashCode;
    return result;
  }

  @override
  String toString() {
    return "${toJson()} isLocationCity = $isLocationCity";
  }
}
