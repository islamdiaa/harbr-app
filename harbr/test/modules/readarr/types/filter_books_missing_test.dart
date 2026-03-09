import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/book/book_statistics.dart';
import 'package:harbr/modules/readarr/core/types/filter_books.dart';

void main() {
  group('ReadarrBooksFilter.MISSING', () {
    group('key', () {
      test('MISSING has key "missing"', () {
        expect(ReadarrBooksFilter.MISSING.key, 'missing');
      });
    });

    group('fromKey', () {
      test('returns MISSING from "missing"', () {
        expect(
          ReadarrBooksFilter.ALL.fromKey('missing'),
          ReadarrBooksFilter.MISSING,
        );
      });
    });

    group('readable', () {
      test('MISSING readable returns non-empty string', () {
        expect(ReadarrBooksFilter.MISSING.readable, isNotEmpty);
      });
    });

    group('filter behavior', () {
      test('returns only books that are monitored AND have 0 files', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Missing Book',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          ReadarrBook(
            id: 2,
            title: 'Downloaded Book',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 1),
          ),
          ReadarrBook(
            id: 3,
            title: 'Unmonitored Missing',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
        ];
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 1);
        expect(result[0].title, 'Missing Book');
      });

      test('excludes unmonitored books even with 0 files', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Unmonitored No Files',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          ReadarrBook(
            id: 2,
            title: 'Unmonitored Also No Files',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
        ];
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result, isEmpty);
      });

      test('excludes monitored books that have files', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Has Files',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 1),
          ),
          ReadarrBook(
            id: 2,
            title: 'Has Multiple Files',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 5),
          ),
        ];
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result, isEmpty);
      });

      test('handles null statistics gracefully (treated as missing)', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'No Stats',
            monitored: true,
            statistics: null,
          ),
        ];
        // statistics is null, so bookFileCount defaults to 0 via ??
        // monitored is true (via ?? false, but it IS true)
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 1);
        expect(result[0].title, 'No Stats');
      });

      test('handles null bookFileCount gracefully (treated as 0)', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Null File Count',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: null),
          ),
        ];
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 1);
        expect(result[0].title, 'Null File Count');
      });

      test('handles null monitored gracefully (treated as false)', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Null Monitored',
            monitored: null,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
        ];
        // monitored ?? false == false, so this should be excluded
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result, isEmpty);
      });

      test('returns empty list for empty input', () {
        final result = ReadarrBooksFilter.MISSING.filter([]);
        expect(result, isEmpty);
      });

      test('returns multiple missing books when applicable', () {
        final books = [
          ReadarrBook(
            id: 1,
            title: 'Missing A',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          ReadarrBook(
            id: 2,
            title: 'Missing B',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          ReadarrBook(
            id: 3,
            title: 'Downloaded C',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 2),
          ),
          ReadarrBook(
            id: 4,
            title: 'Missing D',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
        ];
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 3);
        final titles = result.map((b) => b.title).toList();
        expect(titles, contains('Missing A'));
        expect(titles, contains('Missing B'));
        expect(titles, contains('Missing D'));
      });

      test('complex scenario with mixed states', () {
        final books = [
          // Should be included: monitored=true, fileCount=0
          ReadarrBook(
            id: 1,
            title: 'Missing Monitored',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          // Should NOT be included: monitored=false, fileCount=0
          ReadarrBook(
            id: 2,
            title: 'Missing Unmonitored',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          // Should NOT be included: monitored=true, fileCount=3
          ReadarrBook(
            id: 3,
            title: 'Has Files Monitored',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 3),
          ),
          // Should NOT be included: monitored=false, fileCount=1
          ReadarrBook(
            id: 4,
            title: 'Has Files Unmonitored',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 1),
          ),
          // Should be included: monitored=true, null stats
          ReadarrBook(
            id: 5,
            title: 'Null Stats Monitored',
            monitored: true,
          ),
        ];

        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 2);
        final titles = result.map((b) => b.title).toList();
        expect(titles, contains('Missing Monitored'));
        expect(titles, contains('Null Stats Monitored'));
      });
    });

    group('MISSING vs other filters', () {
      late List<ReadarrBook> books;

      setUp(() {
        books = [
          ReadarrBook(
            id: 1,
            title: 'Mon+Files',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 1),
          ),
          ReadarrBook(
            id: 2,
            title: 'Mon+NoFiles',
            monitored: true,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
          ReadarrBook(
            id: 3,
            title: 'Unmon+Files',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 1),
          ),
          ReadarrBook(
            id: 4,
            title: 'Unmon+NoFiles',
            monitored: false,
            statistics: ReadarrBookStatistics(bookFileCount: 0),
          ),
        ];
      });

      test('ALL returns all 4 books', () {
        expect(ReadarrBooksFilter.ALL.filter(books).length, 4);
      });

      test('MONITORED returns 2 monitored books', () {
        expect(ReadarrBooksFilter.MONITORED.filter(books).length, 2);
      });

      test('UNMONITORED returns 2 unmonitored books', () {
        expect(ReadarrBooksFilter.UNMONITORED.filter(books).length, 2);
      });

      test('MISSING returns only Mon+NoFiles', () {
        final result = ReadarrBooksFilter.MISSING.filter(books);
        expect(result.length, 1);
        expect(result[0].title, 'Mon+NoFiles');
      });

      test('MISSING is a subset of MONITORED', () {
        final missing = ReadarrBooksFilter.MISSING.filter(books);
        final monitored = ReadarrBooksFilter.MONITORED.filter(books);
        for (final book in missing) {
          expect(
            monitored.any((m) => m.id == book.id),
            true,
            reason:
                'Missing book ${book.title} should also appear in monitored',
          );
        }
      });
    });
  });
}
