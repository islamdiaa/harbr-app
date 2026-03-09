// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_books.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadarrBooksSortingAdapter extends TypeAdapter<ReadarrBooksSorting> {
  @override
  final int typeId = 31;

  @override
  ReadarrBooksSorting read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadarrBooksSorting.ALPHABETICAL;
      case 1:
        return ReadarrBooksSorting.DATE_ADDED;
      case 2:
        return ReadarrBooksSorting.SIZE;
      case 3:
        return ReadarrBooksSorting.BOOKS;
      default:
        return ReadarrBooksSorting.ALPHABETICAL;
    }
  }

  @override
  void write(BinaryWriter writer, ReadarrBooksSorting obj) {
    switch (obj) {
      case ReadarrBooksSorting.ALPHABETICAL:
        writer.writeByte(0);
        break;
      case ReadarrBooksSorting.DATE_ADDED:
        writer.writeByte(1);
        break;
      case ReadarrBooksSorting.SIZE:
        writer.writeByte(2);
        break;
      case ReadarrBooksSorting.BOOKS:
        writer.writeByte(3);
        break;
      case ReadarrBooksSorting.RATING:
        writer.writeByte(4);
        break;
      case ReadarrBooksSorting.RELEASE_DATE:
        writer.writeByte(5);
        break;
      case ReadarrBooksSorting.AUTHOR:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadarrBooksSortingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
