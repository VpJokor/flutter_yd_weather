// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInfoData _$WeatherInfoDataFromJson(Map<String, dynamic> json) =>
    WeatherInfoData(
      json['bgPic'] as String?,
      json['smPic'] as String?,
      json['wthr'] as String?,
      json['wd'] as String?,
      json['wp'] as String?,
      (json['type'] as num?)?.toInt(),
      json['notice'] as String?,
    );

Map<String, dynamic> _$WeatherInfoDataToJson(WeatherInfoData instance) =>
    <String, dynamic>{
      'bgPic': instance.bgPic,
      'smPic': instance.smPic,
      'wthr': instance.wthr,
      'wd': instance.wd,
      'wp': instance.wp,
      'type': instance.type,
      'notice': instance.notice,
    };
