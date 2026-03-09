import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/author/author_statistics.dart';

void main() {
  group('ReadarrAuthor', () {
    group('fromJson', () {
      test('deserializes complete JSON payload', () {
        final json = {
          'id': 1,
          'authorMetadataId': 100,
          'status': 'continuing',
          'ended': false,
          'authorName': 'Stephen King',
          'authorNameLastFirst': 'King, Stephen',
          'foreignAuthorId': 'abc-123',
          'titleSlug': 'stephen-king',
          'overview': 'American author of horror and suspense novels.',
          'remotePoster': 'https://example.com/poster.jpg',
          'path': '/books/Stephen King',
          'qualityProfileId': 1,
          'metadataProfileId': 1,
          'monitored': true,
          'monitorNewItems': 'all',
          'genres': ['Horror', 'Thriller', 'Fiction'],
          'cleanName': 'stephenking',
          'sortName': 'king, stephen',
          'sortNameLastFirst': 'king, stephen',
          'tags': [1, 2, 3],
          'added': '2023-01-15T10:30:00Z',
          'rootFolderPath': '/books',
          'statistics': {
            'bookFileCount': 10,
            'bookCount': 15,
            'availableBookCount': 12,
            'totalBookCount': 60,
            'sizeOnDisk': 5368709120,
            'percentOfBooks': 66.7,
          },
        };

        final author = ReadarrAuthor.fromJson(json);

        expect(author.id, 1);
        expect(author.authorMetadataId, 100);
        expect(author.status, 'continuing');
        expect(author.ended, false);
        expect(author.authorName, 'Stephen King');
        expect(author.authorNameLastFirst, 'King, Stephen');
        expect(author.foreignAuthorId, 'abc-123');
        expect(author.titleSlug, 'stephen-king');
        expect(author.overview, 'American author of horror and suspense novels.');
        expect(author.remotePoster, 'https://example.com/poster.jpg');
        expect(author.path, '/books/Stephen King');
        expect(author.qualityProfileId, 1);
        expect(author.metadataProfileId, 1);
        expect(author.monitored, true);
        expect(author.monitorNewItems, 'all');
        expect(author.genres, ['Horror', 'Thriller', 'Fiction']);
        expect(author.cleanName, 'stephenking');
        expect(author.sortName, 'king, stephen');
        expect(author.tags, [1, 2, 3]);
        expect(author.added, isA<DateTime>());
        expect(author.added!.year, 2023);
        expect(author.rootFolderPath, '/books');
        expect(author.statistics?.bookFileCount, 10);
        expect(author.statistics?.bookCount, 15);
        expect(author.statistics?.totalBookCount, 60);
        expect(author.statistics?.sizeOnDisk, 5368709120);
        expect(author.statistics?.percentOfBooks, 66.7);
      });

      test('deserializes empty JSON payload', () {
        final author = ReadarrAuthor.fromJson({});

        expect(author.id, isNull);
        expect(author.authorName, isNull);
        expect(author.sortName, isNull);
        expect(author.monitored, isNull);
        expect(author.statistics, isNull);
        expect(author.genres, isNull);
        expect(author.tags, isNull);
        expect(author.added, isNull);
      });

      test('deserializes JSON with only name', () {
        final json = {
          'authorName': 'Test Author',
        };
        final author = ReadarrAuthor.fromJson(json);

        expect(author.authorName, 'Test Author');
        expect(author.id, isNull);
      });

      test('handles added date parsing', () {
        final json = {
          'added': '2022-12-25T15:00:00Z',
        };
        final author = ReadarrAuthor.fromJson(json);

        expect(author.added, isNotNull);
        expect(author.added!.year, 2022);
        expect(author.added!.month, 12);
        expect(author.added!.day, 25);
      });

      test('handles null added date', () {
        final json = {
          'added': null,
        };
        final author = ReadarrAuthor.fromJson(json);
        expect(author.added, isNull);
      });

      test('handles tags as list of integers', () {
        final json = {
          'tags': [1, 5, 10],
        };
        final author = ReadarrAuthor.fromJson(json);

        expect(author.tags, [1, 5, 10]);
        expect(author.tags!.length, 3);
      });

      test('handles empty tags list', () {
        final json = {
          'tags': <int>[],
        };
        final author = ReadarrAuthor.fromJson(json);

        expect(author.tags, isEmpty);
      });
    });

    group('toJson', () {
      test('serializes all set fields', () {
        final author = ReadarrAuthor(
          id: 1,
          authorName: 'Test Author',
          sortName: 'author, test',
          monitored: true,
          genres: ['Fiction'],
          tags: [1, 2],
        );
        final json = author.toJson();

        expect(json['id'], 1);
        expect(json['authorName'], 'Test Author');
        expect(json['sortName'], 'author, test');
        expect(json['monitored'], true);
        expect(json['genres'], ['Fiction']);
        expect(json['tags'], [1, 2]);
      });

      test('omits null fields', () {
        final author = ReadarrAuthor();
        final json = author.toJson();

        expect(json.containsKey('id'), false);
        expect(json.containsKey('authorName'), false);
        expect(json.containsKey('monitored'), false);
        expect(json.containsKey('statistics'), false);
      });

      test('serializes nested statistics', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(
            bookFileCount: 5,
            bookCount: 10,
            sizeOnDisk: 1024000,
            percentOfBooks: 50.0,
          ),
        );
        final json = author.toJson();

        expect(json['statistics'], isA<Map<String, dynamic>>());
        expect(json['statistics']['bookFileCount'], 5);
        expect(json['statistics']['bookCount'], 10);
        expect(json['statistics']['sizeOnDisk'], 1024000);
        expect(json['statistics']['percentOfBooks'], 50.0);
      });
    });

    group('roundtrip', () {
      test('fromJson -> toJson -> fromJson preserves data', () {
        final originalJson = {
          'id': 42,
          'authorName': 'Roundtrip Author',
          'sortName': 'author, roundtrip',
          'monitored': true,
          'genres': ['Sci-Fi', 'Fantasy'],
          'tags': [1, 3],
          'statistics': {
            'bookFileCount': 8,
            'bookCount': 12,
            'totalBookCount': 20,
            'sizeOnDisk': 2048000,
            'percentOfBooks': 66.7,
          },
        };

        final author = ReadarrAuthor.fromJson(originalJson);
        final serialized = author.toJson();
        final restored = ReadarrAuthor.fromJson(serialized);

        expect(restored.id, 42);
        expect(restored.authorName, 'Roundtrip Author');
        expect(restored.sortName, 'author, roundtrip');
        expect(restored.monitored, true);
        expect(restored.genres, ['Sci-Fi', 'Fantasy']);
        expect(restored.tags, [1, 3]);
        expect(restored.statistics?.bookFileCount, 8);
        expect(restored.statistics?.bookCount, 12);
        expect(restored.statistics?.totalBookCount, 20);
        expect(restored.statistics?.sizeOnDisk, 2048000);
        expect(restored.statistics?.percentOfBooks, 66.7);
      });

      test('empty author roundtrips correctly', () {
        final author = ReadarrAuthor();
        final json = author.toJson();
        final restored = ReadarrAuthor.fromJson(json);

        expect(restored.id, isNull);
        expect(restored.authorName, isNull);
        expect(restored.monitored, isNull);
      });
    });

    group('constructor', () {
      test('creates instance with named parameters', () {
        final author = ReadarrAuthor(
          id: 5,
          authorName: 'Constructor Author',
          monitored: false,
        );

        expect(author.id, 5);
        expect(author.authorName, 'Constructor Author');
        expect(author.monitored, false);
      });
    });
  });

  group('ReadarrAuthorStatistics', () {
    group('fromJson', () {
      test('deserializes all fields', () {
        final json = {
          'bookFileCount': 5,
          'bookCount': 10,
          'availableBookCount': 8,
          'totalBookCount': 20,
          'sizeOnDisk': 1073741824,
          'percentOfBooks': 50.0,
        };
        final stats = ReadarrAuthorStatistics.fromJson(json);

        expect(stats.bookFileCount, 5);
        expect(stats.bookCount, 10);
        expect(stats.availableBookCount, 8);
        expect(stats.totalBookCount, 20);
        expect(stats.sizeOnDisk, 1073741824);
        expect(stats.percentOfBooks, 50.0);
      });

      test('deserializes empty JSON', () {
        final stats = ReadarrAuthorStatistics.fromJson({});

        expect(stats.bookFileCount, isNull);
        expect(stats.bookCount, isNull);
        expect(stats.availableBookCount, isNull);
        expect(stats.totalBookCount, isNull);
        expect(stats.sizeOnDisk, isNull);
        expect(stats.percentOfBooks, isNull);
      });
    });

    group('toJson', () {
      test('serializes all fields', () {
        final stats = ReadarrAuthorStatistics(
          bookFileCount: 3,
          bookCount: 7,
          availableBookCount: 5,
          totalBookCount: 12,
          sizeOnDisk: 500000,
          percentOfBooks: 42.9,
        );
        final json = stats.toJson();

        expect(json['bookFileCount'], 3);
        expect(json['bookCount'], 7);
        expect(json['availableBookCount'], 5);
        expect(json['totalBookCount'], 12);
        expect(json['sizeOnDisk'], 500000);
        expect(json['percentOfBooks'], 42.9);
      });

      test('omits null fields', () {
        final stats = ReadarrAuthorStatistics();
        final json = stats.toJson();

        expect(json.containsKey('bookFileCount'), false);
        expect(json.containsKey('sizeOnDisk'), false);
      });
    });
  });
}
