// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      json['address'] as String?,
      json['address_component'] == null
          ? null
          : AddressComponentData.fromJson(
              json['address_component'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'address': instance.address,
      'address_component': instance.addressComponent,
    };
