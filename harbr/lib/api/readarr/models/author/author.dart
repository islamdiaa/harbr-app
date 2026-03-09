import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/utilities.dart';
import 'package:harbr/api/readarr/models/media/link.dart';
import 'package:harbr/api/readarr/models/media/image.dart';
import 'package:harbr/api/readarr/models/media/rating.dart';
import 'package:harbr/api/readarr/models/author/author_statistics.dart';

part 'author.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrAuthor {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'authorMetadataId')
  int? authorMetadataId;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'ended')
  bool? ended;

  @JsonKey(name: 'authorName')
  String? authorName;

  @JsonKey(name: 'authorNameLastFirst')
  String? authorNameLastFirst;

  @JsonKey(name: 'foreignAuthorId')
  String? foreignAuthorId;

  @JsonKey(name: 'titleSlug')
  String? titleSlug;

  @JsonKey(name: 'overview')
  String? overview;

  @JsonKey(name: 'links')
  List<ReadarrLink>? links;

  @JsonKey(name: 'images')
  List<ReadarrImage>? images;

  @JsonKey(name: 'remotePoster')
  String? remotePoster;

  @JsonKey(name: 'path')
  String? path;

  @JsonKey(name: 'qualityProfileId')
  int? qualityProfileId;

  @JsonKey(name: 'metadataProfileId')
  int? metadataProfileId;

  @JsonKey(name: 'monitored')
  bool? monitored;

  @JsonKey(name: 'monitorNewItems')
  String? monitorNewItems;

  @JsonKey(name: 'genres')
  List<String>? genres;

  @JsonKey(name: 'cleanName')
  String? cleanName;

  @JsonKey(name: 'sortName')
  String? sortName;

  @JsonKey(name: 'sortNameLastFirst')
  String? sortNameLastFirst;

  @JsonKey(name: 'tags')
  List<int>? tags;

  @JsonKey(
    name: 'added',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? added;

  @JsonKey(name: 'ratings')
  ReadarrRating? ratings;

  @JsonKey(name: 'statistics')
  ReadarrAuthorStatistics? statistics;

  @JsonKey(name: 'rootFolderPath')
  String? rootFolderPath;

  ReadarrAuthor({
    this.id,
    this.authorMetadataId,
    this.status,
    this.ended,
    this.authorName,
    this.authorNameLastFirst,
    this.foreignAuthorId,
    this.titleSlug,
    this.overview,
    this.links,
    this.images,
    this.remotePoster,
    this.path,
    this.qualityProfileId,
    this.metadataProfileId,
    this.monitored,
    this.monitorNewItems,
    this.genres,
    this.cleanName,
    this.sortName,
    this.sortNameLastFirst,
    this.tags,
    this.added,
    this.ratings,
    this.statistics,
    this.rootFolderPath,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrAuthor.fromJson(Map<String, dynamic> json) =>
      _$ReadarrAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrAuthorToJson(this);
}
