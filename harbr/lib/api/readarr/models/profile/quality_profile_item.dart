import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/models/profile/quality_profile_item_quality.dart';

part 'quality_profile_item.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrQualityProfileItem {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'quality')
  ReadarrQualityProfileItemQuality? quality;

  @JsonKey(name: 'items')
  List<ReadarrQualityProfileItem>? items;

  @JsonKey(name: 'allowed')
  bool? allowed;

  ReadarrQualityProfileItem({
    this.id,
    this.name,
    this.quality,
    this.items,
    this.allowed,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrQualityProfileItem.fromJson(Map<String, dynamic> json) =>
      _$ReadarrQualityProfileItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrQualityProfileItemToJson(this);
}
