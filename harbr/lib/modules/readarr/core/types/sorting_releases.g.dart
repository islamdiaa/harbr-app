// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_releases.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadarrReleasesSortingAdapter extends TypeAdapter<ReadarrReleasesSorting> {
  @override
  final int typeId = 33;

  @override
  ReadarrReleasesSorting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadarrReleasesSorting.AGE;
      case 1:
        return ReadarrReleasesSorting.ALPHABETICAL;
      case 2:
        return ReadarrReleasesSorting.SEEDERS;
      case 3:
        return ReadarrReleasesSorting.SIZE;
      case 4:
        return ReadarrReleasesSorting.TYPE;
      case 5:
        return ReadarrReleasesSorting.WEIGHT;
      default:
        return ReadarrReleasesSorting.AGE;
    }
  }

  @override
  void write(BinaryWriter writer, ReadarrReleasesSorting obj) {
    switch (obj) {
      case ReadarrReleasesSorting.AGE:
        writer.writeByte(0);
        break;
      case ReadarrReleasesSorting.ALPHABETICAL:
        writer.writeByte(1);
        break;
      case ReadarrReleasesSorting.SEEDERS:
        writer.writeByte(2);
        break;
      case ReadarrReleasesSorting.SIZE:
        writer.writeByte(3);
        break;
      case ReadarrReleasesSorting.TYPE:
        writer.writeByte(4);
        break;
      case ReadarrReleasesSorting.WEIGHT:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadarrReleasesSortingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
