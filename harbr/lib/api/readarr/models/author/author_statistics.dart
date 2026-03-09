import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'author_statistics.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrAuthorStatistics {
  @JsonKey(name: 'bookFileCount')
  int? bookFileCount;

  @JsonKey(name: 'bookCount')
  int? bookCount;

  @JsonKey(name: 'availableBookCount')
  int? availableBookCount;

  @JsonKey(name: 'totalBookCount')
  int? totalBookCount;

  @JsonKey(name: 'sizeOnDisk')
  int? sizeOnDisk;

  @JsonKey(name: 'percentOfBooks')
  double? percentOfBooks;

  ReadarrAuthorStatistics({
    this.bookFileCount,
    this.bookCount,
    this.availableBookCount,
    this.totalBookCount,
    this.sizeOnDisk,
    this.percentOfBooks,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrAuthorStatistics.fromJson(Map<String, dynamic> json) =>
      _$ReadarrAuthorStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrAuthorStatisticsToJson(this);
}
