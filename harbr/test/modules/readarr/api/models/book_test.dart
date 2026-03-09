import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/book/book_statistics.dart';
import 'package:harbr/api/readarr/models/book/edition.dart';
import 'package:harbr/api/readarr/models/author/author.dart';

void main() {
  group('ReadarrBook', () {
    group('fromJson', () {
      test('deserializes complete JSON payload', () {
        final json = {
          'id': 1,
          'title': 'The Shining',
          'seriesTitle': 'The Shining Series',
          'disambiguation': 'First Edition',
          'overview': 'A terrifying novel by Stephen King.',
          'authorId': 42,
          'foreignBookId': 'abc123',
          'titleSlug': 'the-shining',
          'monitored': true,
          'anyEditionOk': true,
          'releaseDate': '1977-01-28T00:00:00Z',
          'pageCount': 447,
          'genres': ['Horror', 'Thriller'],
          'grabbed': false,
          'added': '2023-06-15T10:30:00Z',
          'author': {
            'authorName': 'Stephen King',
          },
          'statistics': {
            'bookFileCount': 1,
            'sizeOnDisk': 1048576,
          },
          'editions': [
            {'id': 10, 'title': 'Hardcover Edition'},
            {'id': 11, 'title': 'Paperback Edition'},
          ],
        };

        final book = ReadarrBook.fromJson(json);

        expect(book.id, 1);
        expect(book.title, 'The Shining');
        expect(book.seriesTitle, 'The Shining Series');
        expect(book.disambiguation, 'First Edition');
        expect(book.overview, 'A terrifying novel by Stephen King.');
        expect(book.authorId, 42);
        expect(book.foreignBookId, 'abc123');
        expect(book.titleSlug, 'the-shining');
        expect(book.monitored, true);
        expect(book.anyEditionOk, true);
        expect(book.pageCount, 447);
        expect(book.genres, ['Horror', 'Thriller']);
        expect(book.grabbed, false);
        expect(book.author?.authorName, 'Stephen King');
        expect(book.statistics?.bookFileCount, 1);
        expect(book.statistics?.sizeOnDisk, 1048576);
        expect(book.editions?.length, 2);
        expect(book.releaseDate, isA<DateTime>());
        expect(book.added, isA<DateTime>());
      });

      test('deserializes minimal JSON payload', () {
        final json = <String, dynamic>{};
        final book = ReadarrBook.fromJson(json);

        expect(book.id, isNull);
        expect(book.title, isNull);
        expect(book.overview, isNull);
        expect(book.monitored, isNull);
        expect(book.grabbed, isNull);
        expect(book.author, isNull);
        expect(book.statistics, isNull);
        expect(book.editions, isNull);
        expect(book.genres, isNull);
        expect(book.pageCount, isNull);
      });

      test('deserializes JSON with only id and title', () {
        final json = {
          'id': 5,
          'title': 'Minimal Book',
        };
        final book = ReadarrBook.fromJson(json);

        expect(book.id, 5);
        expect(book.title, 'Minimal Book');
        expect(book.overview, isNull);
      });

      test('handles releaseDate parsing', () {
        final json = {
          'releaseDate': '2020-07-14T00:00:00Z',
        };
        final book = ReadarrBook.fromJson(json);

        expect(book.releaseDate, isNotNull);
        expect(book.releaseDate!.year, 2020);
        expect(book.releaseDate!.month, 7);
        expect(book.releaseDate!.day, 14);
      });

      test('handles null releaseDate', () {
        final json = {
          'releaseDate': null,
        };
        final book = ReadarrBook.fromJson(json);
        expect(book.releaseDate, isNull);
      });
    });

    group('toJson', () {
      test('serializes to JSON with includeIfNull false', () {
        final book = ReadarrBook(
          id: 1,
          title: 'Test Book',
          monitored: true,
        );
        final json = book.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test Book');
        expect(json['monitored'], true);
        // Fields that are null should not be included (includeIfNull: false)
        expect(json.containsKey('overview'), false);
        expect(json.containsKey('grabbed'), false);
        expect(json.containsKey('author'), false);
      });

      test('serializes and omits null fields', () {
        final book = ReadarrBook();
        final json = book.toJson();

        expect(json.containsKey('id'), false);
        expect(json.containsKey('title'), false);
        expect(json.containsKey('monitored'), false);
      });

      test('serializes statistics correctly', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(
            bookFileCount: 2,
            sizeOnDisk: 5000,
            percentOfBooks: 80.0,
          ),
        );
        final json = book.toJson();

        expect(json['statistics'], isA<Map<String, dynamic>>());
        expect(json['statistics']['bookFileCount'], 2);
        expect(json['statistics']['sizeOnDisk'], 5000);
        expect(json['statistics']['percentOfBooks'], 80.0);
      });

      test('serializes genres correctly', () {
        final book = ReadarrBook(genres: ['Fiction', 'Drama']);
        final json = book.toJson();

        expect(json['genres'], ['Fiction', 'Drama']);
      });

      test('serializes editions correctly', () {
        final book = ReadarrBook(editions: [
          ReadarrEdition(id: 1, title: 'Edition 1'),
          ReadarrEdition(id: 2, title: 'Edition 2'),
        ]);
        final json = book.toJson();

        expect(json['editions'], isA<List>());
        expect(json['editions'].length, 2);
        expect(json['editions'][0]['id'], 1);
        expect(json['editions'][1]['title'], 'Edition 2');
      });
    });

    group('roundtrip', () {
      test('fromJson -> toJson -> fromJson preserves data', () {
        final originalJson = {
          'id': 1,
          'title': 'Roundtrip Book',
          'monitored': true,
          'pageCount': 300,
          'genres': ['Fantasy'],
          'grabbed': false,
          'statistics': {
            'bookFileCount': 1,
            'sizeOnDisk': 2048,
          },
        };

        final book = ReadarrBook.fromJson(originalJson);
        final serialized = book.toJson();
        final restored = ReadarrBook.fromJson(serialized);

        expect(restored.id, 1);
        expect(restored.title, 'Roundtrip Book');
        expect(restored.monitored, true);
        expect(restored.pageCount, 300);
        expect(restored.genres, ['Fantasy']);
        expect(restored.grabbed, false);
        expect(restored.statistics?.bookFileCount, 1);
        expect(restored.statistics?.sizeOnDisk, 2048);
      });
    });

    group('constructor', () {
      test('creates instance with named parameters', () {
        final book = ReadarrBook(
          id: 10,
          title: 'Constructor Book',
          monitored: false,
          pageCount: 150,
        );

        expect(book.id, 10);
        expect(book.title, 'Constructor Book');
        expect(book.monitored, false);
        expect(book.pageCount, 150);
      });

      test('creates empty instance', () {
        final book = ReadarrBook();
        expect(book.id, isNull);
        expect(book.title, isNull);
      });
    });
  });

  group('ReadarrBookStatistics', () {
    group('fromJson', () {
      test('deserializes all fields', () {
        final json = {
          'bookFileCount': 3,
          'bookCount': 10,
          'totalBookCount': 15,
          'sizeOnDisk': 1073741824,
          'percentOfBooks': 66.7,
        };
        final stats = ReadarrBookStatistics.fromJson(json);

        expect(stats.bookFileCount, 3);
        expect(stats.bookCount, 10);
        expect(stats.totalBookCount, 15);
        expect(stats.sizeOnDisk, 1073741824);
        expect(stats.percentOfBooks, 66.7);
      });

      test('deserializes empty JSON', () {
        final stats = ReadarrBookStatistics.fromJson({});

        expect(stats.bookFileCount, isNull);
        expect(stats.bookCount, isNull);
        expect(stats.sizeOnDisk, isNull);
        expect(stats.percentOfBooks, isNull);
      });
    });

    group('toJson', () {
      test('serializes all fields', () {
        final stats = ReadarrBookStatistics(
          bookFileCount: 2,
          bookCount: 5,
          totalBookCount: 8,
          sizeOnDisk: 500000,
          percentOfBooks: 40.0,
        );
        final json = stats.toJson();

        expect(json['bookFileCount'], 2);
        expect(json['bookCount'], 5);
        expect(json['totalBookCount'], 8);
        expect(json['sizeOnDisk'], 500000);
        expect(json['percentOfBooks'], 40.0);
      });

      test('omits null fields', () {
        final stats = ReadarrBookStatistics();
        final json = stats.toJson();

        expect(json.containsKey('bookFileCount'), false);
        expect(json.containsKey('sizeOnDisk'), false);
      });
    });
  });

  group('ReadarrEdition', () {
    group('fromJson', () {
      test('deserializes complete JSON', () {
        final json = {
          'id': 1,
          'bookId': 42,
          'foreignEditionId': 'ed-123',
          'title': 'Hardcover Edition',
          'isbn13': '9780123456789',
          'asin': 'B00ABC1234',
          'pageCount': 500,
          'publisher': 'Penguin Books',
          'monitored': true,
        };
        final edition = ReadarrEdition.fromJson(json);

        expect(edition.id, 1);
        expect(edition.bookId, 42);
        expect(edition.foreignEditionId, 'ed-123');
        expect(edition.title, 'Hardcover Edition');
        expect(edition.isbn13, '9780123456789');
        expect(edition.asin, 'B00ABC1234');
        expect(edition.pageCount, 500);
        expect(edition.publisher, 'Penguin Books');
        expect(edition.monitored, true);
      });

      test('deserializes empty JSON', () {
        final edition = ReadarrEdition.fromJson({});

        expect(edition.id, isNull);
        expect(edition.title, isNull);
        expect(edition.isbn13, isNull);
      });
    });

    group('toJson', () {
      test('serializes and omits null fields', () {
        final edition = ReadarrEdition(
          id: 5,
          title: 'Special Edition',
        );
        final json = edition.toJson();

        expect(json['id'], 5);
        expect(json['title'], 'Special Edition');
        expect(json.containsKey('isbn13'), false);
      });
    });
  });
}
