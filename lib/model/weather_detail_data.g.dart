// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_detail_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDetailData _$WeatherDetailDataFromJson(Map<String, dynamic> json) =>
    WeatherDetailData(
      json['date'] as String?,
      json['sunrise'] as String?,
      json['sunset'] as String?,
      (json['type'] as num?)?.toInt(),
      (json['high'] as num?)?.toInt(),
      (json['low'] as num?)?.toInt(),
      json['wthr'] as String?,
      json['wd'] as String?,
      json['wp'] as String?,
      json['day'] == null
          ? null
          : WeatherInfoData.fromJson(json['day'] as Map<String, dynamic>),
      json['night'] == null
          ? null
          : WeatherInfoData.fromJson(json['night'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDetailDataToJson(WeatherDetailData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'type': instance.type,
      'high': instance.high,
      'low': instance.low,
      'wthr': instance.wthr,
      'wd': instance.wd,
      'wp': instance.wp,
      'day': instance.day,
      'night': instance.night,
    };