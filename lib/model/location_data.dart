import 'package:json_annotation/json_annotation.dart';

import 'address_component_data.dart';

part 'location_data.g.dart';

@JsonSerializable()
class LocationData {
  String? address;
  @JsonKey(name: "address_component")
  AddressComponentData? addressComponent;

  LocationData(
      this.address,
      this.addressComponent,
      );

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
