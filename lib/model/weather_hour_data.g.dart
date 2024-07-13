// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_hour_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherHourData _$WeatherHourDataFromJson(Map<String, dynamic> json) =>
    WeatherHourData(
      json['time'] as String?,
      json['shidu'] as String?,
      (json['type'] as num?)?.toInt(),
      json['type_desc'] as String?,
      json['wd'] as String?,
      json['wp'] as String?,
      (json['wthr'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherHourDataToJson(WeatherHourData instance) =>
    <String, dynamic>{
      'time': instance.time,
      'shidu': instance.shiDu,
      'type': instance.type,
      'type_desc': instance.typeDesc,
      'wd': instance.wd,
      'wp': instance.wp,
      'wthr': instance.temp,
    };
