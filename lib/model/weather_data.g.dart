// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      json['future_remind'] as String?,
      (json['forecast15'] as List<dynamic>?)
          ?.map((e) => WeatherDetailData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['hourfc'] as List<dynamic>?)
          ?.map((e) => WeatherHourData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['meta'] == null
          ? null
          : WeatherMetaData.fromJson(json['meta'] as Map<String, dynamic>),
      json['source'] == null
          ? null
          : WeatherSourceData.fromJson(json['source'] as Map<String, dynamic>),
      json['forecast40_v2'] == null
          ? null
          : WeatherForecast40Data.fromJson(
              json['forecast40_v2'] as Map<String, dynamic>),
      (json['forecast40'] as List<dynamic>?)
          ?.map((e) => WeatherDetailData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['evn'] == null
          ? null
          : WeatherEnvData.fromJson(json['evn'] as Map<String, dynamic>),
      (json['indexes'] as List<dynamic>?)
          ?.map((e) => WeatherIndexData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['alarms'] as List<dynamic>?)
          ?.map((e) => WeatherAlarmsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['observe'] == null
          ? null
          : WeatherObserveData.fromJson(
              json['observe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'future_remind': instance.futureRemind,
      'forecast15': instance.forecast15,
      'hourfc': instance.hourFc,
      'meta': instance.meta,
      'source': instance.source,
      'forecast40_v2': instance.forecast40Data,
      'forecast40': instance.forecast40,
      'evn': instance.evn,
      'indexes': instance.indexes,
      'alarms': instance.alarms,
      'observe': instance.observe,
    };
