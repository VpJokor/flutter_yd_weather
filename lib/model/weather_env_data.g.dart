// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_env_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherEnvData _$WeatherEnvDataFromJson(Map<String, dynamic> json) =>
    WeatherEnvData(
      (json['aqi'] as num?)?.toInt(),
      (json['aqi_level'] as num?)?.toInt(),
      json['aqi_level_name'] as String?,
      (json['co'] as num?)?.toInt(),
      (json['co_level'] as num?)?.toInt(),
      json['mp'] as String?,
      (json['no2'] as num?)?.toInt(),
      (json['no2_level'] as num?)?.toInt(),
      (json['o3'] as num?)?.toInt(),
      (json['o3_level'] as num?)?.toInt(),
      (json['pm10'] as num?)?.toInt(),
      (json['pm10_level'] as num?)?.toInt(),
      (json['pm25'] as num?)?.toInt(),
      (json['pm25_level'] as num?)?.toInt(),
      json['quality'] as String?,
      (json['so2'] as num?)?.toInt(),
      (json['so2_level'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherEnvDataToJson(WeatherEnvData instance) =>
    <String, dynamic>{
      'aqi': instance.aqi,
      'aqi_level': instance.aqiLevel,
      'aqi_level_name': instance.aqiLevelName,
      'co': instance.co,
      'co_level': instance.coLevel,
      'mp': instance.mp,
      'no2': instance.no2,
      'no2_level': instance.no2Level,
      'o3': instance.o3,
      'o3_level': instance.o3Level,
      'pm10': instance.pm10,
      'pm10_level': instance.pm10Level,
      'pm25': instance.pm25,
      'pm25_level': instance.pm25Level,
      'quality': instance.quality,
      'so2': instance.so2,
      'so2_level': instance.so2Level,
    };
