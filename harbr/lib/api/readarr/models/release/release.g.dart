// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadarrRelease _$ReadarrReleaseFromJson(Map<String, dynamic> json) =>
    ReadarrRelease(
      guid: json['guid'] as String?,
      quality: json['quality'] as Map<String, dynamic>?,
      qualityWeight: (json['qualityWeight'] as num?)?.toInt(),
      age: (json['age'] as num?)?.toInt(),
      ageHours: (json['ageHours'] as num?)?.toDouble(),
      ageMinutes: (json['ageMinutes'] as num?)?.toDouble(),
      size: (json['size'] as num?)?.toInt(),
      indexerId: (json['indexerId'] as num?)?.toInt(),
      indexer: json['indexer'] as String?,
      releaseGroup: json['releaseGroup'] as String?,
      subGroup: json['subGroup'] as String?,
      releaseHash: json['releaseHash'] as String?,
      title: json['title'] as String?,
      discography: json['discography'] as bool?,
      sceneSource: json['sceneSource'] as bool?,
      airDate: json['airDate'] as String?,
      authorName: json['authorName'] as String?,
      bookTitle: json['bookTitle'] as String?,
      approved: json['approved'] as bool?,
      temporarilyRejected: json['temporarilyRejected'] as bool?,
      rejected: json['rejected'] as bool?,
      rejections: (json['rejections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      publishDate:
          ReadarrUtilities.dateTimeFromJson(json['publishDate'] as String?),
      commentUrl: json['commentUrl'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
      infoUrl: json['infoUrl'] as String?,
      downloadAllowed: json['downloadAllowed'] as bool?,
      releaseWeight: (json['releaseWeight'] as num?)?.toInt(),
      preferredWordScore: (json['preferredWordScore'] as num?)?.toInt(),
      magnetUrl: json['magnetUrl'] as String?,
      infoHash: json['infoHash'] as String?,
      seeders: (json['seeders'] as num?)?.toInt(),
      leechers: (json['leechers'] as num?)?.toInt(),
      protocol: json['protocol'] as String?,
      bookId: (json['bookId'] as num?)?.toInt(),
      authorId: (json['authorId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadarrReleaseToJson(ReadarrRelease instance) =>
    <String, dynamic>{
      if (instance.guid case final value?) 'guid': value,
      if (instance.quality case final value?) 'quality': value,
      if (instance.qualityWeight case final value?) 'qualityWeight': value,
      if (instance.age case final value?) 'age': value,
      if (instance.ageHours case final value?) 'ageHours': value,
      if (instance.ageMinutes case final value?) 'ageMinutes': value,
      if (instance.size case final value?) 'size': value,
      if (instance.indexerId case final value?) 'indexerId': value,
      if (instance.indexer case final value?) 'indexer': value,
      if (instance.releaseGroup case final value?) 'releaseGroup': value,
      if (instance.subGroup case final value?) 'subGroup': value,
      if (instance.releaseHash case final value?) 'releaseHash': value,
      if (instance.title case final value?) 'title': value,
      if (instance.discography case final value?) 'discography': value,
      if (instance.sceneSource case final value?) 'sceneSource': value,
      if (instance.airDate case final value?) 'airDate': value,
      if (instance.authorName case final value?) 'authorName': value,
      if (instance.bookTitle case final value?) 'bookTitle': value,
      if (instance.approved case final value?) 'approved': value,
      if (instance.temporarilyRejected case final value?)
        'temporarilyRejected': value,
      if (instance.rejected case final value?) 'rejected': value,
      if (instance.rejections case final value?) 'rejections': value,
      if (ReadarrUtilities.dateTimeToJson(instance.publishDate)
          case final value?)
        'publishDate': value,
      if (instance.commentUrl case final value?) 'commentUrl': value,
      if (instance.downloadUrl case final value?) 'downloadUrl': value,
      if (instance.infoUrl case final value?) 'infoUrl': value,
      if (instance.downloadAllowed case final value?) 'downloadAllowed': value,
      if (instance.releaseWeight case final value?) 'releaseWeight': value,
      if (instance.preferredWordScore case final value?)
        'preferredWordScore': value,
      if (instance.magnetUrl case final value?) 'magnetUrl': value,
      if (instance.infoHash case final value?) 'infoHash': value,
      if (instance.seeders case final value?) 'seeders': value,
      if (instance.leechers case final value?) 'leechers': value,
      if (instance.protocol case final value?) 'protocol': value,
      if (instance.bookId case final value?) 'bookId': value,
      if (instance.authorId case final value?) 'authorId': value,
    };
