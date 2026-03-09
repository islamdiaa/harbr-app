import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/utilities.dart';

part 'history_record.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrHistoryRecord {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'bookId')
  int? bookId;

  @JsonKey(name: 'authorId')
  int? authorId;

  @JsonKey(name: 'sourceTitle')
  String? sourceTitle;

  @JsonKey(name: 'quality')
  Map<String, dynamic>? quality;

  @JsonKey(name: 'qualityCutoffNotMet')
  bool? qualityCutoffNotMet;

  @JsonKey(
    name: 'date',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? date;

  @JsonKey(name: 'downloadId')
  String? downloadId;

  @JsonKey(name: 'eventType')
  String? eventType;

  @JsonKey(name: 'data')
  Map<String, dynamic>? data;

  ReadarrHistoryRecord({
    this.id,
    this.bookId,
    this.authorId,
    this.sourceTitle,
    this.quality,
    this.qualityCutoffNotMet,
    this.date,
    this.downloadId,
    this.eventType,
    this.data,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$ReadarrHistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrHistoryRecordToJson(this);
}
