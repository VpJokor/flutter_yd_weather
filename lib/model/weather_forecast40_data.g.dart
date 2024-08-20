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
      (json['down_days'] as num?)?.toInt(),
      (json['rain_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherForecast40DataToJson(
        WeatherForecast40Data instance) =>
    <String, dynamic>{
      'average_temp': instance.averageTemp,
      'up_days': instance.upDays,
      'down_days': instance.downDays,
      'rain_days': instance.rainDays,
    };
