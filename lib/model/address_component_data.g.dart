// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_component_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressComponentData _$AddressComponentDataFromJson(
        Map<String, dynamic> json) =>
    AddressComponentData(
      json['nation'] as String?,
      json['province'] as String?,
      json['city'] as String?,
      json['district'] as String?,
      json['street'] as String?,
      json['street_number'] as String?,
    );

Map<String, dynamic> _$AddressComponentDataToJson(
        AddressComponentData instance) =>
    <String, dynamic>{
      'nation': instance.nation,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'street': instance.street,
      'street_number': instance.streetNumber,
    };
