// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_city_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectCityData _$SelectCityDataFromJson(Map<String, dynamic> json) =>
    SelectCityData(
      (json['hot_international'] as List<dynamic>?)
          ?.map((e) => CityData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['hot_national'] as List<dynamic>?)
          ?.map((e) => CityData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SelectCityDataToJson(SelectCityData instance) =>
    <String, dynamic>{
      'hot_international': instance.hotInternational,
      'hot_national': instance.hotNational,
    };
