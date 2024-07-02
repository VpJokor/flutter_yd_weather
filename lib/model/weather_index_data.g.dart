// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_index_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherIndexData _$WeatherIndexDataFromJson(Map<String, dynamic> json) =>
    WeatherIndexData(
      json['ext'] == null
          ? null
          : WeatherIndexExtData.fromJson(json['ext'] as Map<String, dynamic>),
      json['name'] as String?,
      json['value'] as String?,
      json['desc'] as String?,
    );

Map<String, dynamic> _$WeatherIndexDataToJson(WeatherIndexData instance) =>
    <String, dynamic>{
      'ext': instance.ext,
      'name': instance.name,
      'value': instance.value,
      'desc': instance.desc,
    };
