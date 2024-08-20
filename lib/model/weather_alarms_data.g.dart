// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alarms_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlarmsData _$WeatherAlarmsDataFromJson(Map<String, dynamic> json) =>
    WeatherAlarmsData(
      json['short_title'] as String?,
      json['desc'] as String?,
      json['pub_time'] as String?,
    );

Map<String, dynamic> _$WeatherAlarmsDataToJson(WeatherAlarmsData instance) =>
    <String, dynamic>{
      'short_title': instance.title,
      'desc': instance.desc,
      'pub_time': instance.pubTime,
    };
