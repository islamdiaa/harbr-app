import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/models/wanted_missing/missing_record.dart';

part 'missing.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrMissing {
  @JsonKey(name: 'page')
  int? page;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  @JsonKey(name: 'sortKey')
  String? sortKey;

  @JsonKey(name: 'sortDirection')
  String? sortDirection;

  @JsonKey(name: 'totalRecords')
  int? totalRecords;

  @JsonKey(name: 'records')
  List<ReadarrMissingRecord>? records;

  ReadarrMissing({
    this.page,
    this.pageSize,
    this.sortKey,
    this.sortDirection,
    this.totalRecords,
    this.records,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrMissing.fromJson(Map<String, dynamic> json) =>
      _$ReadarrMissingFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrMissingToJson(this);
}
