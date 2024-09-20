// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CityDataAdapter extends TypeAdapter<CityData> {
  @override
  final int typeId = 1;

  @override
  CityData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CityData(
      fields[0] as String?,
      fields[1] as String?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as int?,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as String?,
    )
      ..street = fields[2] as String?
      ..isLocationCity = fields[10] as bool?
      ..weatherData = fields[11] as SimpleWeatherData?;
  }

  @override
  void write(BinaryWriter writer, CityData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.cityLevelName)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.street)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.upper)
      ..writeByte(5)
      ..write(obj.prov)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.provEn)
      ..writeByte(8)
      ..write(obj.cityId)
      ..writeByte(9)
      ..write(obj.cityLevelId)
      ..writeByte(10)
      ..write(obj.isLocationCity)
      ..writeByte(11)
      ..write(obj.weatherData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityData _$CityDataFromJson(Map<String, dynamic> json) => CityData(
      json['city_level_name'] as String?,
      json['name'] as String?,
      json['country'] as String?,
      json['upper'] as String?,
      json['prov'] as String?,
      (json['type'] as num?)?.toInt(),
      json['prov_en'] as String?,
      json['cityid'] as String?,
      json['city_level_id'] as String?,
    )..street = json['street'] as String?;

Map<String, dynamic> _$CityDataToJson(CityData instance) => <String, dynamic>{
      'city_level_name': instance.cityLevelName,
      'name': instance.name,
      'street': instance.street,
      'country': instance.country,
      'upper': instance.upper,
      'prov': instance.prov,
      'type': instance.type,
      'prov_en': instance.provEn,
      'cityid': instance.cityId,
      'city_level_id': instance.cityLevelId,
    };
