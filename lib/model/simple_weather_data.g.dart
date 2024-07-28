// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_weather_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SimpleWeatherDataAdapter extends TypeAdapter<SimpleWeatherData> {
  @override
  final int typeId = 2;

  @override
  SimpleWeatherData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleWeatherData(
      fields[0] as String?,
      fields[1] as int?,
      fields[2] as int?,
      fields[3] as int?,
      fields[4] as int?,
      fields[5] as String?,
      fields[6] as String?,
      fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleWeatherData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.temp)
      ..writeByte(2)
      ..write(obj.tempHigh)
      ..writeByte(3)
      ..write(obj.tempLow)
      ..writeByte(4)
      ..write(obj.weatherType)
      ..writeByte(5)
      ..write(obj.weatherDesc)
      ..writeByte(6)
      ..write(obj.dayWeatherCardBg)
      ..writeByte(7)
      ..write(obj.nightWeatherCardBg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleWeatherDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
