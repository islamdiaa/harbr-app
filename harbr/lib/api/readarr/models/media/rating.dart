import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrRating {
  @JsonKey(name: 'votes')
  int? votes;

  @JsonKey(name: 'value')
  double? value;

  @JsonKey(name: 'popularity')
  double? popularity;

  ReadarrRating({
    this.votes,
    this.value,
    this.popularity,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrRating.fromJson(Map<String, dynamic> json) =>
      _$ReadarrRatingFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrRatingToJson(this);
}
