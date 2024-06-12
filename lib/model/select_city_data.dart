import 'package:json_annotation/json_annotation.dart';

import 'city_data.dart';

part 'select_city_data.g.dart';

@JsonSerializable()
class SelectCityData {
  @JsonKey(name: "hot_international")
  List<CityData>? hotInternational;
  @JsonKey(name: "hot_national")
  List<CityData>? hotNational;

  SelectCityData(
    this.hotInternational,
    this.hotNational,
  );

  factory SelectCityData.fromJson(Map<String, dynamic> json) =>
      _$SelectCityDataFromJson(json);

  Map<String, dynamic> toJson() => _$SelectCityDataToJson(this);
}
