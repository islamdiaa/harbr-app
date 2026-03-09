import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/utilities.dart';
import 'package:harbr/api/readarr/models/queue/queue_status_message.dart';

part 'queue_record.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrQueueRecord {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'authorId')
  int? authorId;

  @JsonKey(name: 'bookId')
  int? bookId;

  @JsonKey(name: 'quality')
  Map<String, dynamic>? quality;

  @JsonKey(name: 'size')
  double? size;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'sizeleft')
  double? sizeleft;

  @JsonKey(name: 'timeleft')
  String? timeleft;

  @JsonKey(
    name: 'estimatedCompletionTime',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? estimatedCompletionTime;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'trackedDownloadStatus')
  String? trackedDownloadStatus;

  @JsonKey(name: 'trackedDownloadState')
  String? trackedDownloadState;

  @JsonKey(name: 'statusMessages')
  List<ReadarrQueueStatusMessage>? statusMessages;

  @JsonKey(name: 'downloadId')
  String? downloadId;

  @JsonKey(name: 'protocol')
  String? protocol;

  @JsonKey(name: 'downloadClient')
  String? downloadClient;

  @JsonKey(name: 'indexer')
  String? indexer;

  @JsonKey(name: 'outputPath')
  String? outputPath;

  ReadarrQueueRecord({
    this.id,
    this.authorId,
    this.bookId,
    this.quality,
    this.size,
    this.title,
    this.sizeleft,
    this.timeleft,
    this.estimatedCompletionTime,
    this.status,
    this.trackedDownloadStatus,
    this.trackedDownloadState,
    this.statusMessages,
    this.downloadId,
    this.protocol,
    this.downloadClient,
    this.indexer,
    this.outputPath,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrQueueRecord.fromJson(Map<String, dynamic> json) =>
      _$ReadarrQueueRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrQueueRecordToJson(this);
}
