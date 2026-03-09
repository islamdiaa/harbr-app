import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'added_release.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrAddedRelease {
  @JsonKey(name: 'guid')
  String? guid;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'approved')
  bool? approved;

  @JsonKey(name: 'rejected')
  bool? rejected;

  @JsonKey(name: 'quality')
  Map<String, dynamic>? quality;

  ReadarrAddedRelease({
    this.guid,
    this.title,
    this.approved,
    this.rejected,
    this.quality,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrAddedRelease.fromJson(Map<String, dynamic> json) =>
      _$ReadarrAddedReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrAddedReleaseToJson(this);
}
