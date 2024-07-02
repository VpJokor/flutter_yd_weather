// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherMetaData _$WeatherMetaDataFromJson(Map<String, dynamic> json) =>
    WeatherMetaData(
      json['citykey'] as String?,
      json['city'] as String?,
      json['html_url'] as String?,
      json['upper'] as String?,
    );

Map<String, dynamic> _$WeatherMetaDataToJson(WeatherMetaData instance) =>
    <String, dynamic>{
      'citykey': instance.cityKey,
      'city': instance.city,
      'html_url': instance.htmlUrl,
      'upper': instance.upper,
    };
