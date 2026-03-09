# Readarr Module Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add full Readarr (book/audiobook management) support to Harbr, matching feature parity with the existing Sonarr module.

**Architecture:** Fork of Harbr. New `readarr` module following the exact 6-layer pattern: API client (Dio-based), Hive database table, Provider-based state, GoRouter routes, Flutter UI routes, and registration in the core module system. Readarr API uses `/api/v1/` (not `/api/v3/` like Sonarr).

**Tech Stack:** Flutter/Dart, Dio (HTTP), Hive (local DB), Provider (state), GoRouter (navigation), json_serializable (codegen)

---

## Phase 1: Scaffolding & Registration

### Task 1: Create API entry point and barrel files

**Files:**
- Create: `lib/api/readarr/readarr.dart`
- Create: `lib/api/readarr/controllers.dart`
- Create: `lib/api/readarr/models.dart`
- Create: `lib/api/readarr/types.dart`
- Create: `lib/api/readarr/utilities.dart`

**Step 1: Create `lib/api/readarr/readarr.dart`**

```dart
library readarr;

import 'package:dio/dio.dart';
import 'package:harbr/api/readarr/controllers.dart';

class ReadarrAPI {
  ReadarrAPI._internal({
    required this.httpClient,
    required this.author,
    required this.book,
    required this.bookLookup,
    required this.command,
    required this.history,
    required this.metadataProfile,
    required this.profile,
    required this.queue,
    required this.release,
    required this.rootFolder,
    required this.system,
    required this.tag,
    required this.wanted,
  });

  factory ReadarrAPI({
    required String host,
    required String apiKey,
    Map<String, dynamic>? headers,
    bool followRedirects = true,
    int maxRedirects = 5,
  }) {
    Dio _dio = Dio(
      BaseOptions(
        baseUrl: host.endsWith('/') ? '${host}api/v1/' : '$host/api/v1/',
        queryParameters: {'apikey': apiKey},
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: headers,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
      ),
    );
    return ReadarrAPI._internal(
      httpClient: _dio,
      author: ReadarrControllerAuthor(_dio),
      book: ReadarrControllerBook(_dio),
      bookLookup: ReadarrControllerBookLookup(_dio),
      command: ReadarrControllerCommand(_dio),
      history: ReadarrControllerHistory(_dio),
      metadataProfile: ReadarrControllerMetadataProfile(_dio),
      profile: ReadarrControllerProfile(_dio),
      queue: ReadarrControllerQueue(_dio),
      release: ReadarrControllerRelease(_dio),
      rootFolder: ReadarrControllerRootFolder(_dio),
      system: ReadarrControllerSystem(_dio),
      tag: ReadarrControllerTag(_dio),
      wanted: ReadarrControllerWanted(_dio),
    );
  }

  factory ReadarrAPI.from({required Dio client}) {
    return ReadarrAPI._internal(
      httpClient: client,
      author: ReadarrControllerAuthor(client),
      book: ReadarrControllerBook(client),
      bookLookup: ReadarrControllerBookLookup(client),
      command: ReadarrControllerCommand(client),
      history: ReadarrControllerHistory(client),
      metadataProfile: ReadarrControllerMetadataProfile(client),
      profile: ReadarrControllerProfile(client),
      queue: ReadarrControllerQueue(client),
      release: ReadarrControllerRelease(client),
      rootFolder: ReadarrControllerRootFolder(client),
      system: ReadarrControllerSystem(client),
      tag: ReadarrControllerTag(client),
      wanted: ReadarrControllerWanted(client),
    );
  }

  final Dio httpClient;
  final ReadarrControllerAuthor author;
  final ReadarrControllerBook book;
  final ReadarrControllerBookLookup bookLookup;
  final ReadarrControllerCommand command;
  final ReadarrControllerHistory history;
  final ReadarrControllerMetadataProfile metadataProfile;
  final ReadarrControllerProfile profile;
  final ReadarrControllerQueue queue;
  final ReadarrControllerRelease release;
  final ReadarrControllerRootFolder rootFolder;
  final ReadarrControllerSystem system;
  final ReadarrControllerTag tag;
  final ReadarrControllerWanted wanted;
}
```

**Step 2: Create `lib/api/readarr/controllers.dart`** (initially empty library)

```dart
library readarr_commands;

import 'package:harbr/api/readarr/models.dart';
import 'package:harbr/api/readarr/types.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// Author
part 'controllers/author.dart';
part 'controllers/author/get_all_authors.dart';
part 'controllers/author/get_author.dart';
part 'controllers/author/add_author.dart';
part 'controllers/author/update_author.dart';
part 'controllers/author/delete_author.dart';

// Book
part 'controllers/book.dart';
part 'controllers/book/get_all_books.dart';
part 'controllers/book/get_book.dart';
part 'controllers/book/add_book.dart';
part 'controllers/book/update_book.dart';
part 'controllers/book/delete_book.dart';

// Book Lookup
part 'controllers/book_lookup.dart';
part 'controllers/book_lookup/lookup.dart';

// Command
part 'controllers/command.dart';
part 'controllers/command/backup.dart';
part 'controllers/command/author_search.dart';
part 'controllers/command/book_search.dart';
part 'controllers/command/missing_book_search.dart';
part 'controllers/command/refresh_author.dart';
part 'controllers/command/refresh_monitored_downloads.dart';
part 'controllers/command/rescan_folders.dart';
part 'controllers/command/rss_sync.dart';

// History
part 'controllers/history.dart';
part 'controllers/history/get_history.dart';
part 'controllers/history/get_history_by_author.dart';

// Metadata Profile
part 'controllers/metadata_profile.dart';
part 'controllers/metadata_profile/get_metadata_profiles.dart';

// Quality Profile
part 'controllers/profile.dart';
part 'controllers/profile/get_quality_profiles.dart';

// Queue
part 'controllers/queue.dart';
part 'controllers/queue/get_queue.dart';
part 'controllers/queue/delete_queue.dart';

// Release
part 'controllers/release.dart';
part 'controllers/release/get_release.dart';
part 'controllers/release/add_release.dart';

// Root Folder
part 'controllers/root_folder.dart';
part 'controllers/root_folder/get_root_folders.dart';

// System
part 'controllers/system.dart';
part 'controllers/system/get_status.dart';

// Tag
part 'controllers/tag.dart';
part 'controllers/tag/get_all_tags.dart';
part 'controllers/tag/get_tag.dart';
part 'controllers/tag/add_tag.dart';
part 'controllers/tag/delete_tag.dart';
part 'controllers/tag/update_tag.dart';

// Wanted
part 'controllers/wanted.dart';
part 'controllers/wanted/get_missing.dart';
```

**Step 3: Create `lib/api/readarr/models.dart`**

```dart
library readarr_models;

/// Author
export 'models/author/author.dart';
export 'models/author/author_statistics.dart';

/// Book
export 'models/book/book.dart';
export 'models/book/edition.dart';
export 'models/book/book_statistics.dart';

/// Command
export 'models/command/command.dart';

/// History
export 'models/history/history.dart';
export 'models/history/history_record.dart';

/// Profile
export 'models/profile/quality_profile.dart';
export 'models/profile/quality_profile_item.dart';
export 'models/profile/quality_profile_item_quality.dart';
export 'models/profile/metadata_profile.dart';

/// Queue
export 'models/queue/queue.dart';
export 'models/queue/queue_record.dart';
export 'models/queue/queue_status_message.dart';

/// Release
export 'models/release/release.dart';
export 'models/release/added_release.dart';

/// Root Folder
export 'models/root_folder/root_folder.dart';

/// System
export 'models/system/status.dart';

/// Tag
export 'models/tag/tag.dart';

/// Wanted/Missing
export 'models/wanted_missing/missing.dart';
export 'models/wanted_missing/missing_record.dart';

/// Image / Rating / Link
export 'models/media/image.dart';
export 'models/media/rating.dart';
export 'models/media/link.dart';
```

**Step 4: Create `lib/api/readarr/types.dart`**

```dart
library readarr_types;

part 'types/event_type.dart';
part 'types/sort_dir.dart';
part 'types/history_sort_key.dart';
part 'types/queue_sort_key.dart';
part 'types/queue_status_type.dart';
part 'types/queue_tracked_download_state_type.dart';
part 'types/queue_tracked_download_status_type.dart';
part 'types/wanted_missing_sort_key.dart';
```

**Step 5: Create `lib/api/readarr/utilities.dart`**

```dart
library readarr_utilities;

import 'package:harbr/modules/readarr.dart';

class ReadarrUtilities {
  ReadarrUtilities._();

  static DateTime? dateTimeFromJson(String? date) => DateTime.tryParse(date ?? '');
  static String? dateTimeToJson(DateTime? date) => date?.toIso8601String();

  static ReadarrEventType? eventTypeFromJson(String? type) => ReadarrEventType.GRABBED.from(type);
  static String? eventTypeToJson(ReadarrEventType? type) => type?.value;

  static ReadarrHistorySortKey? historySortKeyFromJson(String? key) => ReadarrHistorySortKey.DATE.from(key);
  static String? historySortKeyToJson(ReadarrHistorySortKey? key) => key?.value;

  static ReadarrWantedMissingSortKey? wantedMissingSortKeyFromJson(String? key) => ReadarrWantedMissingSortKey.TITLE.from(key);
  static String? wantedMissingSortKeyToJson(ReadarrWantedMissingSortKey? key) => key?.value;
}
```

**Step 6: Commit**
```bash
git add lib/api/readarr/
git commit -m "feat(readarr): add API entry point and barrel files"
```

---

### Task 2: Create API types (enums)

**Files:**
- Create: `lib/api/readarr/types/event_type.dart`
- Create: `lib/api/readarr/types/sort_dir.dart`
- Create: `lib/api/readarr/types/history_sort_key.dart`
- Create: `lib/api/readarr/types/queue_sort_key.dart`
- Create: `lib/api/readarr/types/queue_status_type.dart`
- Create: `lib/api/readarr/types/queue_tracked_download_state_type.dart`
- Create: `lib/api/readarr/types/queue_tracked_download_status_type.dart`
- Create: `lib/api/readarr/types/wanted_missing_sort_key.dart`

Each type follows the same pattern as Sonarr. Example for `event_type.dart`:

```dart
part of readarr_types;

enum ReadarrEventType {
  GRABBED('grabbed'),
  BOOK_FILE_IMPORTED('bookFileImported'),
  BOOK_FILE_UPGRADED('bookFileUpgraded'),
  BOOK_FILE_RENAMED('bookFileRenamed'),
  BOOK_FILE_DELETED('bookFileDeleted'),
  BOOK_FILE_RETAGGED('bookFileRetagged'),
  DOWNLOAD_FAILED('downloadFailed'),
  DOWNLOAD_IMPORTED('downloadImported'),
  BOOK_IMPORTED('bookImported');

  final String value;
  const ReadarrEventType(this.value);

  ReadarrEventType? from(String? value) {
    for (var type in ReadarrEventType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
```

`sort_dir.dart`:
```dart
part of readarr_types;

enum ReadarrSortDir {
  ASCENDING('ascending'),
  DESCENDING('descending');

  final String value;
  const ReadarrSortDir(this.value);
}
```

`history_sort_key.dart`:
```dart
part of readarr_types;

enum ReadarrHistorySortKey {
  DATE('date'),
  TITLE('title');

  final String value;
  const ReadarrHistorySortKey(this.value);

  ReadarrHistorySortKey? from(String? value) {
    for (var key in ReadarrHistorySortKey.values) {
      if (key.value == value) return key;
    }
    return null;
  }
}
```

`queue_sort_key.dart`:
```dart
part of readarr_types;

enum ReadarrQueueSortKey {
  TIMELEFT('timeleft'),
  TITLE('title'),
  SIZE('size'),
  STATUS('status');

  final String value;
  const ReadarrQueueSortKey(this.value);
}
```

`queue_status_type.dart`:
```dart
part of readarr_types;

enum ReadarrQueueStatus {
  DOWNLOADING('downloading'),
  PAUSED('paused'),
  QUEUED('queued'),
  COMPLETED('completed'),
  DELAY('delay'),
  DOWNLOAD_CLIENT_UNAVAILABLE('downloadClientUnavailable'),
  FAILED('failed'),
  WARNING('warning');

  final String value;
  const ReadarrQueueStatus(this.value);

  ReadarrQueueStatus? from(String? value) {
    for (var status in ReadarrQueueStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }
}
```

`queue_tracked_download_state_type.dart`:
```dart
part of readarr_types;

enum ReadarrTrackedDownloadState {
  DOWNLOADING('downloading'),
  IMPORT_PENDING('importPending'),
  IMPORTING('importing'),
  IMPORTED('imported'),
  FAILED_PENDING('failedPending'),
  FAILED('failed'),
  IGNORED('ignored');

  final String value;
  const ReadarrTrackedDownloadState(this.value);

  ReadarrTrackedDownloadState? from(String? value) {
    for (var state in ReadarrTrackedDownloadState.values) {
      if (state.value == value) return state;
    }
    return null;
  }
}
```

`queue_tracked_download_status_type.dart`:
```dart
part of readarr_types;

enum ReadarrTrackedDownloadStatus {
  OK('ok'),
  WARNING('warning'),
  ERROR('error');

  final String value;
  const ReadarrTrackedDownloadStatus(this.value);

  ReadarrTrackedDownloadStatus? from(String? value) {
    for (var status in ReadarrTrackedDownloadStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }
}
```

`wanted_missing_sort_key.dart`:
```dart
part of readarr_types;

enum ReadarrWantedMissingSortKey {
  TITLE('title'),
  RELEASE_DATE('books.releaseDate');

  final String value;
  const ReadarrWantedMissingSortKey(this.value);

  ReadarrWantedMissingSortKey? from(String? value) {
    for (var key in ReadarrWantedMissingSortKey.values) {
      if (key.value == value) return key;
    }
    return null;
  }
}
```

**Commit:**
```bash
git add lib/api/readarr/types/
git commit -m "feat(readarr): add API type enums"
```

---

### Task 3: Create API models

**Files:** Create all model files under `lib/api/readarr/models/`

Key models based on Readarr API v1:

**`models/author/author.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/modules/readarr.dart';

part 'author.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrAuthor {
  @JsonKey(name: 'id') int? id;
  @JsonKey(name: 'authorMetadataId') int? authorMetadataId;
  @JsonKey(name: 'status') String? status;
  @JsonKey(name: 'ended') bool? ended;
  @JsonKey(name: 'authorName') String? authorName;
  @JsonKey(name: 'authorNameLastFirst') String? authorNameLastFirst;
  @JsonKey(name: 'foreignAuthorId') String? foreignAuthorId;
  @JsonKey(name: 'titleSlug') String? titleSlug;
  @JsonKey(name: 'overview') String? overview;
  @JsonKey(name: 'links') List<ReadarrLink>? links;
  @JsonKey(name: 'images') List<ReadarrImage>? images;
  @JsonKey(name: 'remotePoster') String? remotePoster;
  @JsonKey(name: 'path') String? path;
  @JsonKey(name: 'qualityProfileId') int? qualityProfileId;
  @JsonKey(name: 'metadataProfileId') int? metadataProfileId;
  @JsonKey(name: 'monitored') bool? monitored;
  @JsonKey(name: 'monitorNewItems') String? monitorNewItems;
  @JsonKey(name: 'genres') List<String>? genres;
  @JsonKey(name: 'cleanName') String? cleanName;
  @JsonKey(name: 'sortName') String? sortName;
  @JsonKey(name: 'sortNameLastFirst') String? sortNameLastFirst;
  @JsonKey(name: 'tags') List<int>? tags;
  @JsonKey(name: 'added', toJson: ReadarrUtilities.dateTimeToJson, fromJson: ReadarrUtilities.dateTimeFromJson)
  DateTime? added;
  @JsonKey(name: 'ratings') ReadarrRating? ratings;
  @JsonKey(name: 'statistics') ReadarrAuthorStatistics? statistics;
  @JsonKey(name: 'rootFolderPath') String? rootFolderPath;

  ReadarrAuthor({
    this.id, this.authorMetadataId, this.status, this.ended,
    this.authorName, this.authorNameLastFirst, this.foreignAuthorId,
    this.titleSlug, this.overview, this.links, this.images,
    this.remotePoster, this.path, this.qualityProfileId,
    this.metadataProfileId, this.monitored, this.monitorNewItems,
    this.genres, this.cleanName, this.sortName, this.sortNameLastFirst,
    this.tags, this.added, this.ratings, this.statistics,
    this.rootFolderPath,
  });

  @override
  String toString() => json.encode(toJson());
  factory ReadarrAuthor.fromJson(Map<String, dynamic> json) => _$ReadarrAuthorFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrAuthorToJson(this);
}
```

**`models/author/author_statistics.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'author_statistics.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrAuthorStatistics {
  @JsonKey(name: 'bookFileCount') int? bookFileCount;
  @JsonKey(name: 'bookCount') int? bookCount;
  @JsonKey(name: 'availableBookCount') int? availableBookCount;
  @JsonKey(name: 'totalBookCount') int? totalBookCount;
  @JsonKey(name: 'sizeOnDisk') int? sizeOnDisk;
  @JsonKey(name: 'percentOfBooks') double? percentOfBooks;

  ReadarrAuthorStatistics({
    this.bookFileCount, this.bookCount, this.availableBookCount,
    this.totalBookCount, this.sizeOnDisk, this.percentOfBooks,
  });

  @override
  String toString() => json.encode(toJson());
  factory ReadarrAuthorStatistics.fromJson(Map<String, dynamic> json) => _$ReadarrAuthorStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrAuthorStatisticsToJson(this);
}
```

**`models/book/book.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/modules/readarr.dart';

part 'book.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrBook {
  @JsonKey(name: 'id') int? id;
  @JsonKey(name: 'title') String? title;
  @JsonKey(name: 'seriesTitle') String? seriesTitle;
  @JsonKey(name: 'disambiguation') String? disambiguation;
  @JsonKey(name: 'overview') String? overview;
  @JsonKey(name: 'authorId') int? authorId;
  @JsonKey(name: 'foreignBookId') String? foreignBookId;
  @JsonKey(name: 'titleSlug') String? titleSlug;
  @JsonKey(name: 'monitored') bool? monitored;
  @JsonKey(name: 'anyEditionOk') bool? anyEditionOk;
  @JsonKey(name: 'ratings') ReadarrRating? ratings;
  @JsonKey(name: 'releaseDate', toJson: ReadarrUtilities.dateTimeToJson, fromJson: ReadarrUtilities.dateTimeFromJson)
  DateTime? releaseDate;
  @JsonKey(name: 'pageCount') int? pageCount;
  @JsonKey(name: 'genres') List<String>? genres;
  @JsonKey(name: 'author') ReadarrAuthor? author;
  @JsonKey(name: 'images') List<ReadarrImage>? images;
  @JsonKey(name: 'links') List<ReadarrLink>? links;
  @JsonKey(name: 'statistics') ReadarrBookStatistics? statistics;
  @JsonKey(name: 'added', toJson: ReadarrUtilities.dateTimeToJson, fromJson: ReadarrUtilities.dateTimeFromJson)
  DateTime? added;
  @JsonKey(name: 'editions') List<ReadarrEdition>? editions;
  @JsonKey(name: 'grabbed') bool? grabbed;

  ReadarrBook({
    this.id, this.title, this.seriesTitle, this.disambiguation,
    this.overview, this.authorId, this.foreignBookId, this.titleSlug,
    this.monitored, this.anyEditionOk, this.ratings, this.releaseDate,
    this.pageCount, this.genres, this.author, this.images,
    this.links, this.statistics, this.added, this.editions, this.grabbed,
  });

  @override
  String toString() => json.encode(toJson());
  factory ReadarrBook.fromJson(Map<String, dynamic> json) => _$ReadarrBookFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrBookToJson(this);
}
```

**`models/book/edition.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/modules/readarr.dart';

part 'edition.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrEdition {
  @JsonKey(name: 'id') int? id;
  @JsonKey(name: 'bookId') int? bookId;
  @JsonKey(name: 'foreignEditionId') String? foreignEditionId;
  @JsonKey(name: 'titleSlug') String? titleSlug;
  @JsonKey(name: 'isbn13') String? isbn13;
  @JsonKey(name: 'asin') String? asin;
  @JsonKey(name: 'title') String? title;
  @JsonKey(name: 'overview') String? overview;
  @JsonKey(name: 'format') String? format;
  @JsonKey(name: 'isEbook') bool? isEbook;
  @JsonKey(name: 'disambiguation') String? disambiguation;
  @JsonKey(name: 'publisher') String? publisher;
  @JsonKey(name: 'pageCount') int? pageCount;
  @JsonKey(name: 'releaseDate', toJson: ReadarrUtilities.dateTimeToJson, fromJson: ReadarrUtilities.dateTimeFromJson)
  DateTime? releaseDate;
  @JsonKey(name: 'images') List<ReadarrImage>? images;
  @JsonKey(name: 'links') List<ReadarrLink>? links;
  @JsonKey(name: 'ratings') ReadarrRating? ratings;
  @JsonKey(name: 'monitored') bool? monitored;
  @JsonKey(name: 'manualAdd') bool? manualAdd;

  ReadarrEdition({
    this.id, this.bookId, this.foreignEditionId, this.titleSlug,
    this.isbn13, this.asin, this.title, this.overview, this.format,
    this.isEbook, this.disambiguation, this.publisher, this.pageCount,
    this.releaseDate, this.images, this.links, this.ratings,
    this.monitored, this.manualAdd,
  });

  @override
  String toString() => json.encode(toJson());
  factory ReadarrEdition.fromJson(Map<String, dynamic> json) => _$ReadarrEditionFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrEditionToJson(this);
}
```

**`models/book/book_statistics.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'book_statistics.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrBookStatistics {
  @JsonKey(name: 'bookFileCount') int? bookFileCount;
  @JsonKey(name: 'bookCount') int? bookCount;
  @JsonKey(name: 'totalBookCount') int? totalBookCount;
  @JsonKey(name: 'sizeOnDisk') int? sizeOnDisk;
  @JsonKey(name: 'percentOfBooks') double? percentOfBooks;

  ReadarrBookStatistics({
    this.bookFileCount, this.bookCount, this.totalBookCount,
    this.sizeOnDisk, this.percentOfBooks,
  });

  @override
  String toString() => json.encode(toJson());
  factory ReadarrBookStatistics.fromJson(Map<String, dynamic> json) => _$ReadarrBookStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrBookStatisticsToJson(this);
}
```

**`models/media/image.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrImage {
  @JsonKey(name: 'coverType') String? coverType;
  @JsonKey(name: 'url') String? url;
  @JsonKey(name: 'remoteUrl') String? remoteUrl;

  ReadarrImage({this.coverType, this.url, this.remoteUrl});

  @override
  String toString() => json.encode(toJson());
  factory ReadarrImage.fromJson(Map<String, dynamic> json) => _$ReadarrImageFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrImageToJson(this);
}
```

**`models/media/rating.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrRating {
  @JsonKey(name: 'votes') int? votes;
  @JsonKey(name: 'value') double? value;
  @JsonKey(name: 'popularity') double? popularity;

  ReadarrRating({this.votes, this.value, this.popularity});

  @override
  String toString() => json.encode(toJson());
  factory ReadarrRating.fromJson(Map<String, dynamic> json) => _$ReadarrRatingFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrRatingToJson(this);
}
```

**`models/media/link.dart`:**
```dart
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrLink {
  @JsonKey(name: 'url') String? url;
  @JsonKey(name: 'name') String? name;

  ReadarrLink({this.url, this.name});

  @override
  String toString() => json.encode(toJson());
  factory ReadarrLink.fromJson(Map<String, dynamic> json) => _$ReadarrLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ReadarrLinkToJson(this);
}
```

**Remaining models** (command, history, profile, queue, release, root_folder, system, tag, wanted_missing) follow the same `@JsonSerializable` pattern. Each maps to Readarr's API v1 response schema. Create them mirroring Sonarr's equivalents with Readarr-specific field names.

**`models/command/command.dart`** — Same structure as Sonarr.
**`models/history/history.dart`** — Paginated response wrapper.
**`models/history/history_record.dart`** — Individual history event.
**`models/profile/quality_profile.dart`** — Same as Sonarr.
**`models/profile/quality_profile_item.dart`** — Same as Sonarr.
**`models/profile/quality_profile_item_quality.dart`** — Same as Sonarr.
**`models/profile/metadata_profile.dart`** — Readarr-specific (name, id, minPopularity, etc.).
**`models/queue/queue.dart`** — Paginated wrapper.
**`models/queue/queue_record.dart`** — Download queue item (includes book/author references).
**`models/queue/queue_status_message.dart`** — Same as Sonarr.
**`models/release/release.dart`** — Search result for manual download.
**`models/release/added_release.dart`** — Response after grabbing a release.
**`models/root_folder/root_folder.dart`** — Same as Sonarr.
**`models/system/status.dart`** — Same as Sonarr.
**`models/tag/tag.dart`** — Same as Sonarr.
**`models/wanted_missing/missing.dart`** — Paginated wrapper.
**`models/wanted_missing/missing_record.dart`** — Missing book record.

**Commit:**
```bash
git add lib/api/readarr/models/
git commit -m "feat(readarr): add API models"
```

---

### Task 4: Create API controllers

**Files:** Create all controller files under `lib/api/readarr/controllers/`

Each controller follows the Sonarr pattern: a facade class + private `_command*` functions.

**`controllers/author.dart`:**
```dart
part of readarr_commands;

class ReadarrControllerAuthor {
  final Dio _client;
  ReadarrControllerAuthor(this._client);

  Future<List<ReadarrAuthor>> getAll() async => _commandGetAllAuthors(_client);
  Future<ReadarrAuthor> get({required int authorId}) async => _commandGetAuthor(_client, authorId: authorId);
  Future<ReadarrAuthor> create({required ReadarrAuthor author}) async => _commandAddAuthor(_client, author: author);
  Future<ReadarrAuthor> update({required ReadarrAuthor author}) async => _commandUpdateAuthor(_client, author: author);
  Future<void> delete({required int authorId, bool deleteFiles = false, bool addImportListExclusion = false}) async =>
      _commandDeleteAuthor(_client, authorId: authorId, deleteFiles: deleteFiles, addImportListExclusion: addImportListExclusion);
}
```

**`controllers/author/get_all_authors.dart`:**
```dart
part of readarr_commands;

Future<List<ReadarrAuthor>> _commandGetAllAuthors(Dio client) async {
  Response response = await client.get('author');
  return (response.data as List).map((a) => ReadarrAuthor.fromJson(a)).toList();
}
```

**`controllers/author/get_author.dart`:**
```dart
part of readarr_commands;

Future<ReadarrAuthor> _commandGetAuthor(Dio client, {required int authorId}) async {
  Response response = await client.get('author/$authorId');
  return ReadarrAuthor.fromJson(response.data);
}
```

**`controllers/author/add_author.dart`:**
```dart
part of readarr_commands;

Future<ReadarrAuthor> _commandAddAuthor(Dio client, {required ReadarrAuthor author}) async {
  Response response = await client.post('author', data: author.toJson());
  return ReadarrAuthor.fromJson(response.data);
}
```

**`controllers/author/update_author.dart`:**
```dart
part of readarr_commands;

Future<ReadarrAuthor> _commandUpdateAuthor(Dio client, {required ReadarrAuthor author}) async {
  Response response = await client.put('author', data: author.toJson());
  return ReadarrAuthor.fromJson(response.data);
}
```

**`controllers/author/delete_author.dart`:**
```dart
part of readarr_commands;

Future<void> _commandDeleteAuthor(Dio client, {
  required int authorId,
  bool deleteFiles = false,
  bool addImportListExclusion = false,
}) async {
  await client.delete('author/$authorId', queryParameters: {
    'deleteFiles': deleteFiles,
    'addImportListExclusion': addImportListExclusion,
  });
}
```

**Book, BookLookup, Command, History, MetadataProfile, Profile, Queue, Release, RootFolder, System, Tag, Wanted controllers** all follow identical patterns. Key differences:

- **Book**: CRUD on `/book`, lookup on `/book/lookup?term=...`
- **Command**: POST to `/command` with body `{"name": "AuthorSearch", "authorId": ...}` etc.
- **MetadataProfile**: GET `/metadataprofile` (Readarr-specific)
- **Queue**: GET `/queue?page=1&pageSize=...&sortKey=timeleft&sortDirection=ascending`
- **Wanted**: GET `/wanted/missing?page=1&pageSize=...`

**Commit:**
```bash
git add lib/api/readarr/controllers/
git commit -m "feat(readarr): add API controllers"
```

---

### Task 5: Register Readarr in HarbrModule enum

**Files:**
- Modify: `lib/modules.dart`

**Step 1: Add constant and enum entry**

Add after `const MODULE_TAUTULLI_KEY`:
```dart
const MODULE_READARR_KEY = 'readarr';
```

Add to `HarbrModule` enum after WAKE_ON_LAN:
```dart
@HiveField(12)
READARR(MODULE_READARR_KEY),
```

**Step 2: Add cases to all switch extensions**

In `HarbrModuleEnablementExtension`:
```dart
case HarbrModule.READARR:
  return HarbrProfile.current.readarrEnabled;
```

In `HarbrModuleMetadataExtension` (title, icon, color, etc.):
```dart
case HarbrModule.READARR:
  return 'Readarr';  // title
case HarbrModule.READARR:
  return Icons.book_rounded;  // icon
case HarbrModule.READARR:
  return const Color(0xFF7B68EE);  // color — medium slate blue
```

In `HarbrModuleRoutingExtension`:
```dart
case HarbrModule.READARR:
  return ReadarrRoutes.HOME;  // homeRoute
case HarbrModule.READARR:
  return SettingsRoutes.CONFIGURATION_READARR;  // settingsRoute
```

In `HarbrModuleExtension` (state):
```dart
case HarbrModule.READARR:
  return context.read<ReadarrState>();
```

Add import at top:
```dart
import 'package:harbr/modules/readarr.dart';
```

**Step 3: Commit**
```bash
git add lib/modules.dart
git commit -m "feat(readarr): register in HarbrModule enum"
```

---

### Task 6: Add Readarr fields to HarbrProfile

**Files:**
- Modify: `lib/database/models/profile.dart`

**Step 1: Add fields** (after Overseerr fields, using HiveField indices 44-47):

```dart
// Readarr
@JsonKey() @HiveField(44, defaultValue: false) bool readarrEnabled;
@JsonKey() @HiveField(45, defaultValue: '') String readarrHost;
@JsonKey() @HiveField(46, defaultValue: '') String readarrKey;
@JsonKey() @HiveField(47, defaultValue: <String, String>{}) Map<String, String> readarrHeaders;
```

**Step 2: Add to constructor and factory**

Add to `_internal` constructor parameters and body. Add to factory `HarbrProfile()` default values. Add to `clone()` method.

**Step 3: Commit**
```bash
git add lib/database/models/profile.dart
git commit -m "feat(readarr): add profile connection fields"
```

---

### Task 7: Create Readarr database table

**Files:**
- Create: `lib/database/tables/readarr.dart`
- Modify: `lib/database/table.dart`

**Step 1: Create `lib/database/tables/readarr.dart`:**

```dart
import 'package:harbr/database/table.dart';
import 'package:harbr/modules/readarr/core/types/filter_books.dart';
import 'package:harbr/modules/readarr/core/types/sorting_books.dart';
import 'package:harbr/types/list_view_option.dart';
import 'package:harbr/vendor.dart';

enum ReadarrDatabase<T> with HarbrTableMixin<T> {
  NAVIGATION_INDEX<int>(0),
  ADD_BOOK_DEFAULT_MONITORED<bool>(true),
  ADD_BOOK_DEFAULT_QUALITY_PROFILE<int?>(null),
  ADD_BOOK_DEFAULT_METADATA_PROFILE<int?>(null),
  ADD_BOOK_DEFAULT_ROOT_FOLDER<int?>(null),
  ADD_BOOK_DEFAULT_TAGS<List>([]),
  ADD_BOOK_SEARCH_FOR_MISSING<bool>(false),
  DEFAULT_VIEW_BOOKS<HarbrListViewOption>(HarbrListViewOption.BLOCK_VIEW),
  DEFAULT_FILTERING_BOOKS<ReadarrBooksFilter>(ReadarrBooksFilter.ALL),
  DEFAULT_SORTING_BOOKS<ReadarrBooksSorting>(ReadarrBooksSorting.ALPHABETICAL),
  DEFAULT_SORTING_BOOKS_ASCENDING<bool>(true),
  REMOVE_AUTHOR_DELETE_FILES<bool>(false),
  CONTENT_PAGE_SIZE<int>(10),
  QUEUE_PAGE_SIZE<int>(50),
  QUEUE_REFRESH_RATE<int>(15),
  UPCOMING_FUTURE_DAYS<int>(7);

  @override
  HarbrTable get table => HarbrTable.readarr;

  @override
  final T fallback;
  const ReadarrDatabase(this.fallback);

  @override
  void register() {
    Hive.registerAdapter(ReadarrBooksSortingAdapter());
    Hive.registerAdapter(ReadarrBooksFilterAdapter());
  }
}
```

**Step 2: Add to `lib/database/table.dart`:**

Add import:
```dart
import 'package:harbr/database/tables/readarr.dart';
```

Add entry to `HarbrTable` enum:
```dart
readarr<ReadarrDatabase>('readarr', items: ReadarrDatabase.values),
```

**Step 3: Commit**
```bash
git add lib/database/tables/readarr.dart lib/database/table.dart
git commit -m "feat(readarr): add database table"
```

---

### Task 8: Create module core (state, types, extensions, api_controller, dialogs, webhooks)

**Files:**
- Create: `lib/modules/readarr/core/state.dart`
- Create: `lib/modules/readarr/core/api_controller.dart`
- Create: `lib/modules/readarr/core/types/filter_books.dart`
- Create: `lib/modules/readarr/core/types/sorting_books.dart`
- Create: `lib/modules/readarr/core/types.dart` (barrel)
- Create: `lib/modules/readarr/core/extensions/readarr_author.dart`
- Create: `lib/modules/readarr/core/extensions/readarr_book.dart`
- Create: `lib/modules/readarr/core/extensions/readarr_event_type.dart`
- Create: `lib/modules/readarr/core/extensions/readarr_queue_record.dart`
- Create: `lib/modules/readarr/core/extensions/readarr_history.dart`
- Create: `lib/modules/readarr/core/extensions/readarr_release.dart`
- Create: `lib/modules/readarr/core/extensions.dart` (barrel)
- Create: `lib/modules/readarr/core/dialogs.dart`
- Create: `lib/modules/readarr/core/webhooks.dart`
- Create: `lib/modules/readarr/core.dart` (barrel)

**`core/state.dart`:**
```dart
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/types/list_view_option.dart';

class ReadarrState extends HarbrModuleState {
  ReadarrState() { reset(); }

  @override
  void reset() {
    _authors = null;
    _books = null;
    _missing = null;
    _rootFolders = null;
    _qualityProfiles = null;
    _metadataProfiles = null;
    _tags = null;
    resetProfile();
    if (_enabled) {
      fetchAllAuthors();
      fetchAllBooks();
      fetchMissing();
      fetchRootFolders();
      fetchQualityProfiles();
      fetchMetadataProfiles();
      fetchTags();
    }
    notifyListeners();
  }

  ReadarrAPI? _api;
  ReadarrAPI? get api => _api;
  bool _enabled = false;
  bool get enabled => _enabled;
  String _host = '';
  String _apiKey = '';
  Map<dynamic, dynamic> _headers = {};

  void resetProfile() {
    HarbrProfile _profile = HarbrProfile.current;
    _api = null;
    _enabled = _profile.readarrEnabled;
    _host = _profile.readarrHost;
    _apiKey = _profile.readarrKey;
    _headers = _profile.readarrHeaders;
    if (_enabled) {
      _api = ReadarrAPI(host: _host, apiKey: _apiKey,
          headers: Map<String, dynamic>.from(_headers));
    }
  }

  // Authors
  Future<List<ReadarrAuthor>>? _authors;
  Future<List<ReadarrAuthor>>? get authors => _authors;
  void fetchAllAuthors() {
    if (_api != null) _authors = _api!.author.getAll();
    notifyListeners();
  }

  // Books
  Future<List<ReadarrBook>>? _books;
  Future<List<ReadarrBook>>? get books => _books;
  void fetchAllBooks() {
    if (_api != null) _books = _api!.book.getAll();
    notifyListeners();
  }

  // Missing
  Future<ReadarrMissing>? _missing;
  Future<ReadarrMissing>? get missing => _missing;
  void fetchMissing() {
    if (_api != null) _missing = _api!.wanted.getMissing();
    notifyListeners();
  }

  // Root Folders
  Future<List<ReadarrRootFolder>>? _rootFolders;
  Future<List<ReadarrRootFolder>>? get rootFolders => _rootFolders;
  void fetchRootFolders() {
    if (_api != null) _rootFolders = _api!.rootFolder.getAll();
    notifyListeners();
  }

  // Quality Profiles
  Future<List<ReadarrQualityProfile>>? _qualityProfiles;
  Future<List<ReadarrQualityProfile>>? get qualityProfiles => _qualityProfiles;
  void fetchQualityProfiles() {
    if (_api != null) _qualityProfiles = _api!.profile.getQualityProfiles();
    notifyListeners();
  }

  // Metadata Profiles
  Future<List<ReadarrMetadataProfile>>? _metadataProfiles;
  Future<List<ReadarrMetadataProfile>>? get metadataProfiles => _metadataProfiles;
  void fetchMetadataProfiles() {
    if (_api != null) _metadataProfiles = _api!.metadataProfile.getAll();
    notifyListeners();
  }

  // Tags
  Future<List<ReadarrTag>>? _tags;
  Future<List<ReadarrTag>>? get tags => _tags;
  void fetchTags() {
    if (_api != null) _tags = _api!.tag.getAll();
    notifyListeners();
  }

  // Catalogue view state
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String query) { _searchQuery = query; notifyListeners(); }

  ReadarrBooksSorting _sortType = ReadarrDatabase.DEFAULT_SORTING_BOOKS.read();
  ReadarrBooksSorting get sortType => _sortType;
  set sortType(ReadarrBooksSorting type) { _sortType = type; notifyListeners(); }

  bool _sortAscending = ReadarrDatabase.DEFAULT_SORTING_BOOKS_ASCENDING.read();
  bool get sortAscending => _sortAscending;
  set sortAscending(bool ascending) { _sortAscending = ascending; notifyListeners(); }

  ReadarrBooksFilter _filterType = ReadarrDatabase.DEFAULT_FILTERING_BOOKS.read();
  ReadarrBooksFilter get filterType => _filterType;
  set filterType(ReadarrBooksFilter type) { _filterType = type; notifyListeners(); }

  // Image URL helpers
  String getAuthorPosterURL(ReadarrAuthor? author) {
    if (author?.images == null || author!.images!.isEmpty) return '';
    for (var img in author.images!) {
      if (img.coverType == 'poster') return '$_host${img.url}';
    }
    return author.remotePoster ?? '';
  }

  String getBookCoverURL(ReadarrBook? book) {
    if (book?.images == null || book!.images!.isEmpty) return '';
    for (var img in book.images!) {
      if (img.coverType == 'cover') return '$_host${img.url}';
    }
    return '';
  }
}
```

**`core/types/filter_books.dart`:**
```dart
import 'package:harbr/vendor.dart';

part 'filter_books.g.dart';

@HiveType(typeId: 30, adapterName: 'ReadarrBooksFilterAdapter')
enum ReadarrBooksFilter {
  @HiveField(0) ALL('all', 'All'),
  @HiveField(1) MONITORED('monitored', 'Monitored'),
  @HiveField(2) UNMONITORED('unmonitored', 'Unmonitored');

  final String key;
  final String readable;
  const ReadarrBooksFilter(this.key, this.readable);
}
```

**`core/types/sorting_books.dart`:**
```dart
import 'package:harbr/vendor.dart';

part 'sorting_books.g.dart';

@HiveType(typeId: 31, adapterName: 'ReadarrBooksSortingAdapter')
enum ReadarrBooksSorting {
  @HiveField(0) ALPHABETICAL('alphabetical', 'Alphabetical'),
  @HiveField(1) DATE_ADDED('dateAdded', 'Date Added'),
  @HiveField(2) SIZE('size', 'Size'),
  @HiveField(3) BOOKS('books', 'Books');

  final String key;
  final String readable;
  const ReadarrBooksSorting(this.key, this.readable);
}
```

**`core/extensions/readarr_author.dart`:**
```dart
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:intl/intl.dart';

extension ReadarrAuthorExtension on ReadarrAuthor {
  ReadarrAuthor clone() => ReadarrAuthor.fromJson(toJson());

  String get harbrTitle => authorName ?? 'Unknown Author';
  String get harbrSortTitle => sortName ?? harbrTitle;
  String get harbrOverview => (overview?.isNotEmpty ?? false) ? overview! : 'No summary available.';
  String get harbrGenres => (genres?.isNotEmpty ?? false) ? genres!.join(', ') : 'Unknown';
  String get harbrDateAdded => added != null ? DateFormat('MMMM dd, y').format(added!.toLocal()) : 'Unknown';
  String get harbrSizeOnDisk => statistics?.sizeOnDisk?.asBytes(decimals: 1) ?? '0.0 B';
  int get harbrBookFileCount => statistics?.bookFileCount ?? 0;
  int get harbrBookCount => statistics?.bookCount ?? 0;
  int get harbrTotalBookCount => statistics?.totalBookCount ?? 0;
  double get harbrPercentOfBooks => statistics?.percentOfBooks ?? 0.0;
  String get harbrBookProgress => '$harbrBookFileCount/$harbrBookCount';

  String harbrTags(List<ReadarrTag> tags) {
    if (this.tags == null || this.tags!.isEmpty) return 'None';
    return this.tags!.map((id) {
      final tag = tags.firstWhere((t) => t.id == id, orElse: () => ReadarrTag(label: 'Unknown'));
      return tag.label;
    }).join(', ');
  }
}
```

**`core/extensions/readarr_book.dart`:**
```dart
import 'package:harbr/modules/readarr.dart';
import 'package:intl/intl.dart';

extension ReadarrBookExtension on ReadarrBook {
  ReadarrBook clone() => ReadarrBook.fromJson(toJson());

  String get harbrTitle => title ?? 'Unknown Book';
  String get harbrAuthorTitle => author?.authorName ?? 'Unknown Author';
  String get harbrOverview => (overview?.isNotEmpty ?? false) ? overview! : 'No summary available.';
  String get harbrGenres => (genres?.isNotEmpty ?? false) ? genres!.join(', ') : 'Unknown';
  String get harbrPageCount => '${pageCount ?? 0} pages';
  String get harbrReleaseDate => releaseDate != null ? DateFormat('MMMM dd, y').format(releaseDate!.toLocal()) : 'Unknown';
  String get harbrDateAdded => added != null ? DateFormat('MMMM dd, y').format(added!.toLocal()) : 'Unknown';
  int get harbrEditionCount => editions?.length ?? 0;
  bool get harbrIsGrabbed => grabbed ?? false;
  bool get harbrIsMonitored => monitored ?? false;
}
```

**Remaining extension files** follow the same pattern — adding `luna`-prefixed display getters to each API model type.

**`core/api_controller.dart`:** Wraps API mutations with snackbar feedback. Methods: `addAuthor`, `removeAuthor`, `toggleAuthorMonitored`, `updateAuthor`, `addBook`, `removeBook`, `toggleBookMonitored`, `downloadRelease`, `addTag`, `backupDatabase`, `runRSSSync`, `updateLibrary`, `missingBookSearch`, `refreshAuthor`, `authorSearch`, `bookSearch`, `removeFromQueue`.

**`core/dialogs.dart`:** Module-specific dialogs (confirm delete author, confirm delete book, set page size).

**`core/webhooks.dart`:** `ReadarrWebhooks().handle(data)` — push notification webhook handler.

**`core.dart`** (barrel):
```dart
export 'package:harbr/database/tables/readarr.dart';
export 'core/api_controller.dart';
export 'core/dialogs.dart';
export 'core/extensions.dart';
export 'core/state.dart';
export 'core/types.dart';
export 'core/webhooks.dart';
```

**Commit:**
```bash
git add lib/modules/readarr/core/ lib/modules/readarr/core.dart
git commit -m "feat(readarr): add module core — state, types, extensions, api_controller"
```

---

## Phase 2: Router & UI Routes

### Task 9: Create router routes

**Files:**
- Create: `lib/router/routes/readarr.dart`
- Modify: `lib/router/routes.dart`

**`lib/router/routes/readarr.dart`:**
```dart
import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/readarr/core/state.dart';
import 'package:harbr/modules/readarr/routes/add_book/route.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/route.dart';
import 'package:harbr/modules/readarr/routes/author_details/route.dart';
import 'package:harbr/modules/readarr/routes/book_details/route.dart';
import 'package:harbr/modules/readarr/routes/edit_author/route.dart';
import 'package:harbr/modules/readarr/routes/history/route.dart';
import 'package:harbr/modules/readarr/routes/queue/route.dart';
import 'package:harbr/modules/readarr/routes/readarr/route.dart';
import 'package:harbr/modules/readarr/routes/releases/route.dart';
import 'package:harbr/modules/readarr/routes/tags/route.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

enum ReadarrRoutes with HarbrRoutesMixin {
  HOME('/readarr'),
  ADD_BOOK('add_book'),
  ADD_BOOK_DETAILS('details'),
  AUTHOR('author/:author'),
  AUTHOR_EDIT('edit'),
  BOOK('book/:book'),
  HISTORY('history'),
  QUEUE('queue'),
  RELEASES('releases'),
  TAGS('tags');

  @override
  final String path;
  const ReadarrRoutes(this.path);

  @override
  HarbrModule get module => HarbrModule.READARR;

  @override
  bool isModuleEnabled(BuildContext context) {
    return context.read<ReadarrState>().enabled;
  }

  @override
  GoRoute get routes {
    switch (this) {
      case ReadarrRoutes.HOME:
        return route(widget: const ReadarrRoute());
      case ReadarrRoutes.ADD_BOOK:
        return route(builder: (_, state) {
          final query = state.uri.queryParameters['query'] ?? '';
          return AddBookRoute(query: query);
        });
      case ReadarrRoutes.ADD_BOOK_DETAILS:
        return route(builder: (_, state) {
          return AddBookDetailsRoute(book: state.extra as ReadarrBook);
        });
      case ReadarrRoutes.AUTHOR:
        return route(builder: (_, state) {
          final authorId = int.parse(state.pathParameters['author']!);
          return AuthorDetailsRoute(authorId: authorId);
        });
      case ReadarrRoutes.AUTHOR_EDIT:
        return route(builder: (_, state) {
          return EditAuthorRoute(author: state.extra as ReadarrAuthor);
        });
      case ReadarrRoutes.BOOK:
        return route(builder: (_, state) {
          final bookId = int.parse(state.pathParameters['book']!);
          return BookDetailsRoute(bookId: bookId);
        });
      case ReadarrRoutes.HISTORY:
        return route(widget: const HistoryRoute());
      case ReadarrRoutes.QUEUE:
        return route(widget: const QueueRoute());
      case ReadarrRoutes.RELEASES:
        return route(builder: (_, state) {
          final bookId = int.tryParse(state.uri.queryParameters['bookId'] ?? '');
          return ReleasesRoute(bookId: bookId);
        });
      case ReadarrRoutes.TAGS:
        return route(widget: const TagsRoute());
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case ReadarrRoutes.HOME:
        return [
          ReadarrRoutes.ADD_BOOK.routes,
          ReadarrRoutes.AUTHOR.routes,
          ReadarrRoutes.BOOK.routes,
          ReadarrRoutes.HISTORY.routes,
          ReadarrRoutes.QUEUE.routes,
          ReadarrRoutes.RELEASES.routes,
          ReadarrRoutes.TAGS.routes,
        ];
      case ReadarrRoutes.ADD_BOOK:
        return [ReadarrRoutes.ADD_BOOK_DETAILS.routes];
      case ReadarrRoutes.AUTHOR:
        return [ReadarrRoutes.AUTHOR_EDIT.routes];
      default:
        return const [];
    }
  }
}
```

**Modify `lib/router/routes.dart`:** Add import and enum entry:
```dart
import 'package:harbr/router/routes/readarr.dart';
// ...
readarr('readarr', root: ReadarrRoutes.HOME),
```

**Commit:**
```bash
git add lib/router/routes/readarr.dart lib/router/routes.dart
git commit -m "feat(readarr): add router routes"
```

---

### Task 10: Create UI routes — Home, Catalogue, Missing, More

**Files:** Create the main route and tab pages under `lib/modules/readarr/routes/`

Structure mirrors Sonarr:
```
routes/
  readarr/route.dart                    # Main scaffold with 4 tabs
  readarr/widgets/navigation_bar.dart   # Bottom nav: Catalogue, Upcoming, Missing, More
  readarr/widgets/appbar_add_book_action.dart
  readarr/widgets/appbar_global_settings_action.dart
  catalogue/route.dart                  # Author grid/list with search, sort, filter
  catalogue/widgets/search_bar.dart
  catalogue/widgets/search_bar_filter_button.dart
  catalogue/widgets/search_bar_sort_button.dart
  catalogue/widgets/author_tile.dart
  missing/route.dart
  missing/widgets/missing_tile.dart
  more/route.dart                       # Links to History, Queue, Tags
  upcoming/route.dart                   # Calendar of upcoming book releases
  upcoming/widgets/upcoming_tile.dart
```

Each route widget follows the exact Sonarr pattern:
- `StatefulWidget` with `AutomaticKeepAliveClientMixin`
- `Selector<ReadarrState, ...>` → `FutureBuilder` → filter/sort → list/grid view
- Navigation bar with 4 tabs: Books (book icon), Upcoming (calendar icon), Missing (event_busy icon), More (more_horiz icon)

**Commit:**
```bash
git add lib/modules/readarr/routes/readarr/ lib/modules/readarr/routes/catalogue/ lib/modules/readarr/routes/missing/ lib/modules/readarr/routes/more/ lib/modules/readarr/routes/upcoming/
git commit -m "feat(readarr): add home, catalogue, missing, more, upcoming routes"
```

---

### Task 11: Create UI routes — Author Details, Book Details, Edit Author

**Files:**
```
routes/
  author_details/route.dart
  author_details/state.dart
  author_details/widgets/navigation_bar.dart    # Overview, Books, History tabs
  author_details/widgets/page_overview.dart
  author_details/widgets/page_books.dart
  author_details/widgets/page_history.dart
  author_details/widgets/book_tile.dart
  author_details/widgets/appbar_settings_action.dart
  book_details/route.dart
  book_details/state.dart
  book_details/widgets/book_information_block.dart
  book_details/widgets/book_description_tile.dart
  edit_author/route.dart
  edit_author/state.dart
  edit_author/widgets/bottom_action_bar.dart
  edit_author/widgets/tile_quality_profile.dart
  edit_author/widgets/tile_metadata_profile.dart
  edit_author/widgets/tile_monitored.dart
  edit_author/widgets/tile_tags.dart
  edit_author/widgets/tile_author_path.dart
```

**Commit:**
```bash
git add lib/modules/readarr/routes/author_details/ lib/modules/readarr/routes/book_details/ lib/modules/readarr/routes/edit_author/
git commit -m "feat(readarr): add author details, book details, edit author routes"
```

---

### Task 12: Create UI routes — Add Book, Queue, History, Releases, Tags

**Files:**
```
routes/
  add_book/route.dart
  add_book/state.dart
  add_book/widgets/appbar.dart
  add_book/widgets/page_search.dart
  add_book/widgets/search_results_tile.dart
  add_book_details/route.dart
  add_book_details/state.dart
  add_book_details/widgets/bottom_action_bar.dart
  add_book_details/widgets/tile_quality_profile.dart
  add_book_details/widgets/tile_metadata_profile.dart
  add_book_details/widgets/tile_root_folder.dart
  add_book_details/widgets/tile_monitored.dart
  add_book_details/widgets/tile_tags.dart
  queue/route.dart
  queue/state.dart
  queue/widgets/queue_tile.dart
  history/route.dart
  history/widgets/history_tile.dart
  releases/route.dart
  releases/state.dart
  releases/widgets/release_tile.dart
  tags/route.dart
  tags/widgets/tag_tile.dart
  tags/widgets/appbar_action_add_tag.dart
```

**Commit:**
```bash
git add lib/modules/readarr/routes/add_book/ lib/modules/readarr/routes/add_book_details/ lib/modules/readarr/routes/queue/ lib/modules/readarr/routes/history/ lib/modules/readarr/routes/releases/ lib/modules/readarr/routes/tags/
git commit -m "feat(readarr): add book search, queue, history, releases, tags routes"
```

---

### Task 13: Create barrel files and module registration

**Files:**
- Create: `lib/modules/readarr.dart` (top-level barrel)
- Create: `lib/modules/readarr/routes.dart` (routes barrel)
- Create: barrel `.dart` files for each route subdirectory

**`lib/modules/readarr.dart`:**
```dart
export '../api/readarr/readarr.dart';
export '../api/readarr/controllers.dart';
export '../api/readarr/models.dart';
export '../api/readarr/types.dart';
export '../api/readarr/utilities.dart';
export 'readarr/core.dart';
export 'readarr/routes.dart';
```

**`lib/modules/readarr/routes.dart`:**
```dart
export 'routes/add_book.dart';
export 'routes/add_book_details.dart';
export 'routes/author_details.dart';
export 'routes/book_details.dart';
export 'routes/catalogue.dart';
export 'routes/edit_author.dart';
export 'routes/history.dart';
export 'routes/missing.dart';
export 'routes/more.dart';
export 'routes/queue.dart';
export 'routes/readarr.dart';
export 'routes/releases.dart';
export 'routes/tags.dart';
export 'routes/upcoming.dart';
```

**Commit:**
```bash
git add lib/modules/readarr.dart lib/modules/readarr/routes.dart lib/modules/readarr/routes/*.dart
git commit -m "feat(readarr): add barrel files"
```

---

## Phase 3: Settings & Build

### Task 14: Add Readarr settings pages

**Files:**
- Create: `lib/modules/settings/routes/configuration_readarr/route.dart`
- Create: `lib/modules/settings/routes/configuration_readarr/pages.dart`
- Create: `lib/modules/settings/routes/configuration_readarr/pages/connection_details.dart`
- Create: `lib/modules/settings/routes/configuration_readarr/pages/default_options.dart`
- Create: `lib/modules/settings/routes/configuration_readarr/pages/default_pages.dart`
- Create: `lib/modules/settings/routes/configuration_readarr/pages/headers.dart`
- Modify: `lib/router/routes/settings.dart` — Add readarr settings routes

Settings pages mirror Sonarr's configuration pages exactly:
- **Connection Details**: Host, API Key, Test Connection, Custom Headers
- **Default Options**: Sort/filter/view preferences for books catalogue
- **Default Pages**: Default tab navigation indices
- **Headers**: Delegates to `SettingsHeaderRoute(module: HarbrModule.READARR)`

Add to `SettingsRoutes` enum:
```dart
CONFIGURATION_READARR('readarr'),
CONFIGURATION_READARR_CONNECTION_DETAILS('connection_details'),
CONFIGURATION_READARR_CONNECTION_DETAILS_HEADERS('headers'),
CONFIGURATION_READARR_DEFAULT_OPTIONS('default_options'),
CONFIGURATION_READARR_DEFAULT_PAGES('default_pages'),
```

**Commit:**
```bash
git add lib/modules/settings/routes/configuration_readarr/ lib/router/routes/settings.dart
git commit -m "feat(readarr): add settings/configuration pages"
```

---

### Task 15: Run code generation and verify build

**Step 1: Run build_runner** to generate `.g.dart` files for all `@JsonSerializable` and `@HiveType` annotated classes:

```bash
cd harbr && flutter pub run build_runner build --delete-conflicting-outputs
```

**Step 2: Verify no build errors:**
```bash
flutter analyze
```

**Step 3: Fix any issues found by analysis**

**Step 4: Commit generated files:**
```bash
git add -A
git commit -m "feat(readarr): run code generation and fix build issues"
```

---

### Task 16: Test the module

**Step 1: Run existing tests to verify nothing is broken:**
```bash
flutter test
```

**Step 2: Manual testing checklist:**
- [ ] App launches without crashes
- [ ] Readarr appears in the navigation drawer
- [ ] Settings > Readarr shows connection configuration
- [ ] Test connection works with a valid Readarr instance
- [ ] Library loads and shows authors
- [ ] Author details show books
- [ ] Book search works
- [ ] Add book flow completes
- [ ] Queue shows active downloads
- [ ] History shows past activity
- [ ] Missing shows wanted books

**Step 3: Final commit:**
```bash
git add -A
git commit -m "feat(readarr): complete Readarr module for Harbr"
```

---

## Summary

| Phase | Tasks | Files Created | Files Modified |
|-------|-------|--------------|----------------|
| 1: Scaffolding | 1-8 | ~50 | 3 |
| 2: Router & UI | 9-13 | ~40 | 1 |
| 3: Settings & Build | 14-16 | ~6 | 1 |
| **Total** | **16** | **~96** | **5** |

Each task is independently committable. The API layer (Tasks 1-4) has no Flutter dependencies and could be extracted as a standalone Dart package later.
