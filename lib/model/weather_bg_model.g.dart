// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherBgModel _$WeatherBgModelFromJson(Map<String, dynamic> json) =>
    WeatherBgModel(
      supportEdit: json['supportEdit'] as bool? ?? false,
      colors: (json['colors'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      nightColors: (json['nightColors'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$WeatherBgModelToJson(WeatherBgModel instance) =>
    <String, dynamic>{
      'supportEdit': instance.supportEdit,
      'colors': instance.colors,
      'nightColors': instance.nightColors,
      'isSelected': instance.isSelected,
    };
