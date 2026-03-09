import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'root_folder.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrRootFolder {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'path')
  String? path;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'defaultMetadataProfileId')
  int? defaultMetadataProfileId;

  @JsonKey(name: 'defaultQualityProfileId')
  int? defaultQualityProfileId;

  @JsonKey(name: 'defaultMonitorOption')
  String? defaultMonitorOption;

  @JsonKey(name: 'defaultNewItemMonitorOption')
  String? defaultNewItemMonitorOption;

  @JsonKey(name: 'defaultTags')
  List<int>? defaultTags;

  @JsonKey(name: 'accessible')
  bool? accessible;

  @JsonKey(name: 'freeSpace')
  int? freeSpace;

  @JsonKey(name: 'totalSpace')
  int? totalSpace;

  ReadarrRootFolder({
    this.id,
    this.path,
    this.name,
    this.defaultMetadataProfileId,
    this.defaultQualityProfileId,
    this.defaultMonitorOption,
    this.defaultNewItemMonitorOption,
    this.defaultTags,
    this.accessible,
    this.freeSpace,
    this.totalSpace,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrRootFolder.fromJson(Map<String, dynamic> json) =>
      _$ReadarrRootFolderFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrRootFolderToJson(this);
}
