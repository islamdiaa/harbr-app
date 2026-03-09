// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_books.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadarrBooksFilterAdapter extends TypeAdapter<ReadarrBooksFilter> {
  @override
  final int typeId = 30;

  @override
  ReadarrBooksFilter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadarrBooksFilter.ALL;
      case 1:
        return ReadarrBooksFilter.MONITORED;
      case 2:
        return ReadarrBooksFilter.UNMONITORED;
      default:
        return ReadarrBooksFilter.ALL;
    }
  }

  @override
  void write(BinaryWriter writer, ReadarrBooksFilter obj) {
    switch (obj) {
      case ReadarrBooksFilter.ALL:
        writer.writeByte(0);
        break;
      case ReadarrBooksFilter.MONITORED:
        writer.writeByte(1);
        break;
      case ReadarrBooksFilter.UNMONITORED:
        writer.writeByte(2);
        break;
      case ReadarrBooksFilter.MISSING:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadarrBooksFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
