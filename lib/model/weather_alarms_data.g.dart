// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alarms_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlarmsData _$WeatherAlarmsDataFromJson(Map<String, dynamic> json) =>
    WeatherAlarmsData(
      json['degree'] as String?,
      json['short_title'] as String?,
      json['desc'] as String?,
      json['details'] as String?,
    );

Map<String, dynamic> _$WeatherAlarmsDataToJson(WeatherAlarmsData instance) =>
    <String, dynamic>{
      'degree': instance.degree,
      'short_title': instance.title,
      'desc': instance.desc,
      'details': instance.details,
    };
