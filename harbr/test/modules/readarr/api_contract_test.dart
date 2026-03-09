/// API Contract Tests for Readarr
///
/// These tests validate that our Dart model deserialization matches
/// the actual JSON responses from a real Readarr v1 API instance.
///
/// Requires a running Readarr instance at READARR_URL with READARR_API_KEY.
/// Default: http://192.168.1.142:8787 with key 9c6eaa476ccf45b1825b8405f8baf756
///
/// Run with:
///   flutter test test/modules/readarr/api_contract_test.dart
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/history/history.dart';
import 'package:harbr/api/readarr/models/history/history_record.dart';
import 'package:harbr/api/readarr/models/tag/tag.dart';
import 'package:harbr/api/readarr/models/root_folder/root_folder.dart';
import 'package:harbr/api/readarr/models/profile/quality_profile.dart';
import 'package:harbr/api/readarr/models/profile/metadata_profile.dart';

final _baseUrl = Platform.environment['READARR_URL'] ??
    'http://192.168.1.142:8787';
final _apiKey = Platform.environment['READARR_API_KEY'] ??
    '9c6eaa476ccf45b1825b8405f8baf756';

Future<dynamic> _apiGet(String path,
    [Map<String, String>? queryParams]) async {
  final uri = Uri.parse('$_baseUrl/api/v1/$path').replace(
    queryParameters: {
      'apikey': _apiKey,
      ...?queryParams,
    },
  );
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw HttpException(
        'API returned ${response.statusCode}: ${body.substring(0, 200.clamp(0, body.length))}',
      );
    }
    return json.decode(body);
  } finally {
    client.close();
  }
}

void main() {
  group('Readarr API Contract Tests', () {
    late bool serverReachable;

    setUpAll(() async {
      try {
        final result = await _apiGet('system/status');
        serverReachable = result is Map && result['appName'] == 'Readarr';
        if (serverReachable) {
          // ignore: avoid_print
          print('Connected to Readarr ${result['version']} at $_baseUrl');
        }
      } catch (e) {
        serverReachable = false;
        // ignore: avoid_print
        print('WARNING: Readarr server not reachable at $_baseUrl - '
            'contract tests will be skipped. Error: $e');
      }
    });

    group('GET /author', () {
      test('deserializes author list', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('author') as List;
        expect(jsonList, isNotEmpty, reason: 'Expected at least 1 author');

        for (final json in jsonList) {
          final author = ReadarrAuthor.fromJson(json as Map<String, dynamic>);
          expect(author.id, isNotNull);
          expect(author.authorName, isNotNull);
          expect(author.authorName, isNotEmpty);
          expect(author.monitored, isNotNull);
          expect(author.path, isNotNull);
          expect(author.qualityProfileId, isNotNull);
          expect(author.metadataProfileId, isNotNull);

          // Roundtrip: toJson -> fromJson should preserve values
          final roundtrip = ReadarrAuthor.fromJson(author.toJson());
          expect(roundtrip.id, author.id);
          expect(roundtrip.authorName, author.authorName);
          expect(roundtrip.monitored, author.monitored);
        }
      });

      test('deserializes single author with detail fields', () async {
        if (!serverReachable) return;

        final json =
            await _apiGet('author/1') as Map<String, dynamic>;
        final author = ReadarrAuthor.fromJson(json);

        expect(author.id, 1);
        expect(author.authorName, 'Isaac Asimov');
        expect(author.overview, contains('biochemistry'));
        expect(author.genres, isNotNull);
        expect(author.genres, isNotEmpty);
        expect(author.ratings, isNotNull);
        expect(author.ratings!.value, greaterThan(0));
        expect(author.links, isNotNull);
        expect(author.images, isNotNull);
        expect(author.tags, isNotNull);
        expect(author.added, isNotNull);
        expect(author.sortName, isNotNull);
      });
    });

    group('GET /book', () {
      test('deserializes book list', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('book') as List;
        expect(jsonList, isNotEmpty, reason: 'Expected at least 1 book');

        for (final json in jsonList) {
          final book = ReadarrBook.fromJson(json as Map<String, dynamic>);
          expect(book.id, isNotNull);
          expect(book.title, isNotNull);
          expect(book.title, isNotEmpty);
          expect(book.monitored, isNotNull);
          expect(book.authorId, isNotNull);
          expect(book.foreignBookId, isNotNull);

          // Roundtrip
          final roundtrip = ReadarrBook.fromJson(book.toJson());
          expect(roundtrip.id, book.id);
          expect(roundtrip.title, book.title);
        }
      });

      test('deserializes single book with full details', () async {
        if (!serverReachable) return;

        final json = await _apiGet('book/4') as Map<String, dynamic>;
        final book = ReadarrBook.fromJson(json);

        expect(book.id, 4);
        expect(book.title, 'Dune');
        expect(book.authorId, 2);
        expect(book.foreignBookId, 'b-dune');
        expect(book.monitored, true);
        expect(book.anyEditionOk, true);
        expect(book.pageCount, 688);
        expect(book.genres, contains('Science Fiction'));
        expect(book.ratings, isNotNull);
        expect(book.ratings!.value, closeTo(4.25, 0.01));
        expect(book.releaseDate, isNotNull);
        expect(book.links, isNotNull);
        expect(book.added, isNotNull);

        // Author should be embedded
        expect(book.author, isNotNull);
        expect(book.author!.authorName, 'Frank Herbert');
      });

      test('book with monitored=false deserializes correctly', () async {
        if (!serverReachable) return;

        final json = await _apiGet('book/3') as Map<String, dynamic>;
        final book = ReadarrBook.fromJson(json);

        expect(book.id, 3);
        expect(book.title, 'Second Foundation');
        expect(book.monitored, false);
      });
    });

    group('GET /history', () {
      test('deserializes paginated history', () async {
        if (!serverReachable) return;

        final json = await _apiGet('history', {
          'page': '1',
          'pageSize': '20',
          'sortKey': 'date',
          'sortDirection': 'descending',
        }) as Map<String, dynamic>;

        final history = ReadarrHistory.fromJson(json);
        expect(history.totalRecords, isNotNull);
        expect(history.totalRecords, greaterThan(0));
        expect(history.records, isNotNull);
        expect(history.records, isNotEmpty);

        for (final record in history.records!) {
          expect(record.id, isNotNull);
          expect(record.bookId, isNotNull);
          expect(record.authorId, isNotNull);
          expect(record.sourceTitle, isNotNull);
          expect(record.eventType, isNotNull);
          expect(record.date, isNotNull);
          expect(record.quality, isNotNull);
        }
      });

      test('history record has correct event types', () async {
        if (!serverReachable) return;

        final json = await _apiGet('history', {
          'page': '1',
          'pageSize': '20',
          'sortKey': 'date',
          'sortDirection': 'ascending',
        }) as Map<String, dynamic>;

        final history = ReadarrHistory.fromJson(json);
        final eventTypes =
            history.records!.map((r) => r.eventType).toSet();

        // Our synthetic data has grabbed, bookFileImported, downloadFailed
        expect(
          eventTypes,
          containsAll(['grabbed', 'bookFileImported', 'downloadFailed']),
        );
      });

      test('history record roundtrips correctly', () async {
        if (!serverReachable) return;

        final json = await _apiGet('history', {
          'page': '1',
          'pageSize': '1',
          'sortKey': 'date',
          'sortDirection': 'descending',
        }) as Map<String, dynamic>;

        final record = ReadarrHistoryRecord.fromJson(
          (json['records'] as List).first as Map<String, dynamic>,
        );

        final roundtrip = ReadarrHistoryRecord.fromJson(record.toJson());
        expect(roundtrip.id, record.id);
        expect(roundtrip.sourceTitle, record.sourceTitle);
        expect(roundtrip.eventType, record.eventType);
        expect(roundtrip.bookId, record.bookId);
      });
    });

    group('GET /tag', () {
      test('deserializes tag list', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('tag') as List;
        expect(jsonList, isNotEmpty);

        for (final json in jsonList) {
          final tag = ReadarrTag.fromJson(json as Map<String, dynamic>);
          expect(tag.id, isNotNull);
          expect(tag.label, isNotNull);

          final roundtrip = ReadarrTag.fromJson(tag.toJson());
          expect(roundtrip.id, tag.id);
          expect(roundtrip.label, tag.label);
        }

        final labels = jsonList
            .map((j) =>
                ReadarrTag.fromJson(j as Map<String, dynamic>).label)
            .where((l) => l != null && l.isNotEmpty)
            .toSet();
        expect(labels, containsAll(['favorites', 'sci-fi', 'classics']));
      });
    });

    group('GET /rootfolder', () {
      test('deserializes root folder list', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('rootfolder') as List;
        expect(jsonList, isNotEmpty);

        final folder =
            ReadarrRootFolder.fromJson(jsonList.first as Map<String, dynamic>);
        expect(folder.id, isNotNull);
        expect(folder.path, '/books');
        expect(folder.name, isNotNull);
        expect(folder.accessible, isNotNull);
      });
    });

    group('GET /qualityprofile', () {
      test('deserializes quality profiles', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('qualityprofile') as List;
        expect(jsonList, isNotEmpty);

        for (final json in jsonList) {
          final profile =
              ReadarrQualityProfile.fromJson(json as Map<String, dynamic>);
          expect(profile.id, isNotNull);
          expect(profile.name, isNotNull);
          expect(profile.name, isNotEmpty);
        }

        final names = jsonList
            .map((j) =>
                ReadarrQualityProfile.fromJson(j as Map<String, dynamic>).name)
            .toSet();
        expect(names, containsAll(['eBook', 'Spoken']));
      });
    });

    group('GET /metadataprofile', () {
      test('deserializes metadata profiles', () async {
        if (!serverReachable) return;

        final jsonList = await _apiGet('metadataprofile') as List;
        expect(jsonList, isNotEmpty);

        for (final json in jsonList) {
          final profile =
              ReadarrMetadataProfile.fromJson(json as Map<String, dynamic>);
          expect(profile.id, isNotNull);
          expect(profile.name, isNotNull);
        }

        final names = jsonList
            .map((j) =>
                ReadarrMetadataProfile.fromJson(j as Map<String, dynamic>)
                    .name)
            .toSet();
        expect(names, containsAll(['Standard', 'None']));
      });
    });

    group('GET /queue', () {
      test('deserializes empty queue', () async {
        if (!serverReachable) return;

        final json = await _apiGet('queue', {
          'page': '1',
          'pageSize': '20',
        }) as Map<String, dynamic>;

        expect(json['totalRecords'], isNotNull);
        expect(json['records'], isNotNull);
        expect(json['records'], isList);
      });
    });

    group('Data integrity', () {
      test('author-book relationship is consistent', () async {
        if (!serverReachable) return;

        final authors = (await _apiGet('author') as List)
            .map((j) => ReadarrAuthor.fromJson(j as Map<String, dynamic>))
            .toList();
        final books = (await _apiGet('book') as List)
            .map((j) => ReadarrBook.fromJson(j as Map<String, dynamic>))
            .toList();

        final authorIds = authors.map((a) => a.id).toSet();

        for (final book in books) {
          expect(
            authorIds.contains(book.authorId),
            true,
            reason:
                'Book "${book.title}" references authorId=${book.authorId} '
                'which should exist in authors list',
          );
        }
      });

      test('history references valid books and authors', () async {
        if (!serverReachable) return;

        final books = (await _apiGet('book') as List)
            .map((j) => ReadarrBook.fromJson(j as Map<String, dynamic>))
            .toList();
        final authors = (await _apiGet('author') as List)
            .map((j) => ReadarrAuthor.fromJson(j as Map<String, dynamic>))
            .toList();
        final historyJson = await _apiGet('history', {
          'page': '1',
          'pageSize': '100',
          'sortKey': 'date',
          'sortDirection': 'descending',
        }) as Map<String, dynamic>;
        final history = ReadarrHistory.fromJson(historyJson);

        final bookIds = books.map((b) => b.id).toSet();
        final authorIds = authors.map((a) => a.id).toSet();

        for (final record in history.records!) {
          expect(bookIds.contains(record.bookId), true,
              reason: 'History record ${record.id} references '
                  'bookId=${record.bookId}');
          expect(authorIds.contains(record.authorId), true,
              reason: 'History record ${record.id} references '
                  'authorId=${record.authorId}');
        }
      });

      test('tags referenced by authors exist', () async {
        if (!serverReachable) return;

        final tags = (await _apiGet('tag') as List)
            .map((j) => ReadarrTag.fromJson(j as Map<String, dynamic>))
            .toList();
        final authors = (await _apiGet('author') as List)
            .map((j) => ReadarrAuthor.fromJson(j as Map<String, dynamic>))
            .toList();

        final tagIds = tags.map((t) => t.id).toSet();

        for (final author in authors) {
          if (author.tags != null) {
            for (final tagId in author.tags!) {
              expect(tagIds.contains(tagId), true,
                  reason: 'Author "${author.authorName}" references '
                      'tag $tagId');
            }
          }
        }
      });
    });
  });
}
