// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_observe_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherObserveData _$WeatherObserveDataFromJson(Map<String, dynamic> json) =>
    WeatherObserveData(
      json['day'] == null
          ? null
          : WeatherInfoData.fromJson(json['day'] as Map<String, dynamic>),
      json['night'] == null
          ? null
          : WeatherInfoData.fromJson(json['night'] as Map<String, dynamic>),
      (json['type'] as num?)?.toInt(),
      (json['temp'] as num?)?.toInt(),
      json['tigan'] as String?,
      json['up_time'] as String?,
      json['wthr'] as String?,
      json['wd'] as String?,
      json['wp'] as String?,
      json['shidu'] as String?,
    );

Map<String, dynamic> _$WeatherObserveDataToJson(WeatherObserveData instance) =>
    <String, dynamic>{
      'day': instance.day,
      'night': instance.night,
      'type': instance.type,
      'temp': instance.temp,
      'tigan': instance.tiGan,
      'up_time': instance.upTime,
      'wthr': instance.wthr,
      'wd': instance.wd,
      'wp': instance.wp,
      'shidu': instance.shiDu,
    };
