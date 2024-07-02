// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast40_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecast40Data _$WeatherForecast40DataFromJson(
        Map<String, dynamic> json) =>
    WeatherForecast40Data(
      (json['average_temp'] as num?)?.toInt(),
      (json['up_days'] as num?)?.toInt(),
      (json['rain_days'] as num?)?.toInt(),
      json['temp_icon'] as String?,
      json['rain_icon'] as String?,
    );

Map<String, dynamic> _$WeatherForecast40DataToJson(
        WeatherForecast40Data instance) =>
    <String, dynamic>{
      'average_temp': instance.averageTemp,
      'up_days': instance.upDays,
      'rain_days': instance.rainDays,
      'temp_icon': instance.tempIcon,
      'rain_icon': instance.rainIcon,
    };
