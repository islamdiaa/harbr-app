import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/utilities.dart';
import 'package:harbr/api/readarr/models/media/image.dart';
import 'package:harbr/api/readarr/models/media/link.dart';
import 'package:harbr/api/readarr/models/media/rating.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/book/book_statistics.dart';
import 'package:harbr/api/readarr/models/book/edition.dart';

part 'book.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrBook {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'seriesTitle')
  String? seriesTitle;

  @JsonKey(name: 'disambiguation')
  String? disambiguation;

  @JsonKey(name: 'overview')
  String? overview;

  @JsonKey(name: 'authorId')
  int? authorId;

  @JsonKey(name: 'foreignBookId')
  String? foreignBookId;

  @JsonKey(name: 'titleSlug')
  String? titleSlug;

  @JsonKey(name: 'monitored')
  bool? monitored;

  @JsonKey(name: 'anyEditionOk')
  bool? anyEditionOk;

  @JsonKey(name: 'ratings')
  ReadarrRating? ratings;

  @JsonKey(
    name: 'releaseDate',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? releaseDate;

  @JsonKey(name: 'pageCount')
  int? pageCount;

  @JsonKey(name: 'genres')
  List<String>? genres;

  @JsonKey(name: 'author')
  ReadarrAuthor? author;

  @JsonKey(name: 'images')
  List<ReadarrImage>? images;

  @JsonKey(name: 'links')
  List<ReadarrLink>? links;

  @JsonKey(name: 'statistics')
  ReadarrBookStatistics? statistics;

  @JsonKey(
    name: 'added',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? added;

  @JsonKey(name: 'editions')
  List<ReadarrEdition>? editions;

  @JsonKey(name: 'grabbed')
  bool? grabbed;

  ReadarrBook({
    this.id,
    this.title,
    this.seriesTitle,
    this.disambiguation,
    this.overview,
    this.authorId,
    this.foreignBookId,
    this.titleSlug,
    this.monitored,
    this.anyEditionOk,
    this.ratings,
    this.releaseDate,
    this.pageCount,
    this.genres,
    this.author,
    this.images,
    this.links,
    this.statistics,
    this.added,
    this.editions,
    this.grabbed,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrBook.fromJson(Map<String, dynamic> json) =>
      _$ReadarrBookFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrBookToJson(this);
}
