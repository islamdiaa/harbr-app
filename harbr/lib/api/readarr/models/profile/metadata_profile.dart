import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'metadata_profile.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrMetadataProfile {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'minPopularity')
  double? minPopularity;

  @JsonKey(name: 'skipMissingDate')
  bool? skipMissingDate;

  @JsonKey(name: 'skipMissingIsbn')
  bool? skipMissingIsbn;

  @JsonKey(name: 'skipPartsAndSets')
  bool? skipPartsAndSets;

  @JsonKey(name: 'skipSeriesSecondary')
  bool? skipSeriesSecondary;

  @JsonKey(name: 'allowedLanguages')
  String? allowedLanguages;

  @JsonKey(name: 'minPages')
  int? minPages;

  ReadarrMetadataProfile({
    this.id,
    this.name,
    this.minPopularity,
    this.skipMissingDate,
    this.skipMissingIsbn,
    this.skipPartsAndSets,
    this.skipSeriesSecondary,
    this.allowedLanguages,
    this.minPages,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrMetadataProfile.fromJson(Map<String, dynamic> json) =>
      _$ReadarrMetadataProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrMetadataProfileToJson(this);
}
