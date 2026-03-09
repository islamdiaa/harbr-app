// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_releases.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadarrReleasesFilterAdapter extends TypeAdapter<ReadarrReleasesFilter> {
  @override
  final int typeId = 32;

  @override
  ReadarrReleasesFilter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadarrReleasesFilter.ALL;
      case 1:
        return ReadarrReleasesFilter.APPROVED;
      case 2:
        return ReadarrReleasesFilter.REJECTED;
      default:
        return ReadarrReleasesFilter.ALL;
    }
  }

  @override
  void write(BinaryWriter writer, ReadarrReleasesFilter obj) {
    switch (obj) {
      case ReadarrReleasesFilter.ALL:
        writer.writeByte(0);
        break;
      case ReadarrReleasesFilter.APPROVED:
        writer.writeByte(1);
        break;
      case ReadarrReleasesFilter.REJECTED:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadarrReleasesFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
