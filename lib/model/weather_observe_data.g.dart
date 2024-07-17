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
      (json['uv_index'] as num?)?.toInt(),
      (json['uv_index_max'] as num?)?.toInt(),
      json['uv_level'] as String?,
      json['pressure'] as String?,
      json['visibility'] as String?,
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
      'uv_index': instance.uvIndex,
      'uv_index_max': instance.uvIndexMax,
      'uv_level': instance.uvLevel,
      'pressure': instance.pressure,
      'visibility': instance.visibility,
    };
