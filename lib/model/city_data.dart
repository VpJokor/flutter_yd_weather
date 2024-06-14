import 'package:flutter_yd_weather/config/constants.dart';
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

  factory CityData.fromJson(Map<String, dynamic> json) =>
      _$CityDataFromJson(json);

  Map<String, dynamic> toJson() => _$CityDataToJson(this);
}