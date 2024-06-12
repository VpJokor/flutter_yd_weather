import 'package:json_annotation/json_annotation.dart';

part 'address_component_data.g.dart';

@JsonSerializable()
class AddressComponentData {
  String? nation;
  String? province;
  String? city;
  String? district;
  String? street;
  @JsonKey(name: "street_number")
  String? streetNumber;

  AddressComponentData(
    this.nation,
    this.province,
    this.city,
    this.district,
    this.street,
    this.streetNumber,
  );

  factory AddressComponentData.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentDataToJson(this);
}
