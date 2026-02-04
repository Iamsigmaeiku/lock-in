// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStatisticsAdapter extends TypeAdapter<DailyStatistics> {
  @override
  final int typeId = 3;

  @override
  DailyStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStatistics(
      date: fields[0] as DateTime,
      completedPomodoros: fields[1] as int,
      totalFocusTimeInSeconds: fields[2] as int,
      completedTasks: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyStatistics obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completedPomodoros)
      ..writeByte(2)
      ..write(obj.totalFocusTimeInSeconds)
      ..writeByte(3)
      ..write(obj.completedTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
