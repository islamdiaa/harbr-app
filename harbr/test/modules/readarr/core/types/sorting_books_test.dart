import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/author/author_statistics.dart';
import 'package:harbr/modules/readarr/core/types/sorting_books.dart';

void main() {
  group('ReadarrBooksSorting', () {
    group('key', () {
      test('ALPHABETICAL has key "abc"', () {
        expect(ReadarrBooksSorting.ALPHABETICAL.key, 'abc');
      });

      test('DATE_ADDED has key "date_added"', () {
        expect(ReadarrBooksSorting.DATE_ADDED.key, 'date_added');
      });

      test('SIZE has key "size"', () {
        expect(ReadarrBooksSorting.SIZE.key, 'size');
      });

      test('BOOKS has key "books"', () {
        expect(ReadarrBooksSorting.BOOKS.key, 'books');
      });
    });

    group('readable', () {
      // Note: .tr() returns the raw key when easy_localization is not initialized in tests
      test('ALPHABETICAL readable returns a non-empty string', () {
        expect(ReadarrBooksSorting.ALPHABETICAL.readable, isNotEmpty);
      });

      test('DATE_ADDED readable returns a non-empty string', () {
        expect(ReadarrBooksSorting.DATE_ADDED.readable, isNotEmpty);
      });

      test('SIZE readable returns a non-empty string', () {
        expect(ReadarrBooksSorting.SIZE.readable, isNotEmpty);
      });

      test('BOOKS readable returns a non-empty string', () {
        expect(ReadarrBooksSorting.BOOKS.readable, isNotEmpty);
      });
    });

    group('fromKey', () {
      test('returns ALPHABETICAL from "abc"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('abc'),
          ReadarrBooksSorting.ALPHABETICAL,
        );
      });

      test('returns DATE_ADDED from "date_added"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('date_added'),
          ReadarrBooksSorting.DATE_ADDED,
        );
      });

      test('returns SIZE from "size"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('size'),
          ReadarrBooksSorting.SIZE,
        );
      });

      test('returns BOOKS from "books"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('books'),
          ReadarrBooksSorting.BOOKS,
        );
      });

      test('returns null for unknown key', () {
        expect(ReadarrBooksSorting.ALPHABETICAL.fromKey('invalid'), isNull);
      });

      test('returns null for null key', () {
        expect(ReadarrBooksSorting.ALPHABETICAL.fromKey(null), isNull);
      });

      test('returns null for empty key', () {
        expect(ReadarrBooksSorting.ALPHABETICAL.fromKey(''), isNull);
      });
    });

    group('sort - ALPHABETICAL', () {
      test('sorts ascending by sortName', () {
        final authors = [
          ReadarrAuthor(sortName: 'Tolkien, J.R.R.'),
          ReadarrAuthor(sortName: 'Asimov, Isaac'),
          ReadarrAuthor(sortName: 'King, Stephen'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL.sort(authors, true);

        expect(result[0].sortName, 'Asimov, Isaac');
        expect(result[1].sortName, 'King, Stephen');
        expect(result[2].sortName, 'Tolkien, J.R.R.');
      });

      test('sorts descending by sortName', () {
        final authors = [
          ReadarrAuthor(sortName: 'Asimov, Isaac'),
          ReadarrAuthor(sortName: 'Tolkien, J.R.R.'),
          ReadarrAuthor(sortName: 'King, Stephen'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL.sort(authors, false);

        expect(result[0].sortName, 'Tolkien, J.R.R.');
        expect(result[1].sortName, 'King, Stephen');
        expect(result[2].sortName, 'Asimov, Isaac');
      });

      test('is case insensitive', () {
        final authors = [
          ReadarrAuthor(sortName: 'zebra'),
          ReadarrAuthor(sortName: 'Alpha'),
          ReadarrAuthor(sortName: 'beta'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL.sort(authors, true);

        expect(result[0].sortName, 'Alpha');
        expect(result[1].sortName, 'beta');
        expect(result[2].sortName, 'zebra');
      });

      test('handles null sortName', () {
        final authors = [
          ReadarrAuthor(sortName: 'Beta'),
          ReadarrAuthor(sortName: null),
          ReadarrAuthor(sortName: 'Alpha'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL.sort(authors, true);

        // null sortName becomes '' which sorts before other strings
        expect(result[0].sortName, isNull);
        expect(result[1].sortName, 'Alpha');
        expect(result[2].sortName, 'Beta');
      });
    });

    group('sort - DATE_ADDED', () {
      test('sorts ascending by date added', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'C',
            added: DateTime(2023, 3, 1),
          ),
          ReadarrAuthor(
            sortName: 'A',
            added: DateTime(2023, 1, 1),
          ),
          ReadarrAuthor(
            sortName: 'B',
            added: DateTime(2023, 2, 1),
          ),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'C');
      });

      test('sorts descending by date added', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'A',
            added: DateTime(2023, 1, 1),
          ),
          ReadarrAuthor(
            sortName: 'C',
            added: DateTime(2023, 3, 1),
          ),
          ReadarrAuthor(
            sortName: 'B',
            added: DateTime(2023, 2, 1),
          ),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED.sort(authors, false);

        expect(result[0].sortName, 'C');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'A');
      });

      test('uses alphabetical as tiebreaker for same date', () {
        final sameDate = DateTime(2023, 1, 1);
        final authors = [
          ReadarrAuthor(sortName: 'Beta', added: sameDate),
          ReadarrAuthor(sortName: 'Alpha', added: sameDate),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED.sort(authors, true);

        expect(result[0].sortName, 'Alpha');
        expect(result[1].sortName, 'Beta');
      });

      test('handles null dates ascending - null goes to end', () {
        final authors = [
          ReadarrAuthor(sortName: 'B', added: null),
          ReadarrAuthor(sortName: 'A', added: DateTime(2023, 1, 1)),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
      });
    });

    group('sort - SIZE', () {
      test('sorts ascending by size on disk', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'C',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 3000),
          ),
          ReadarrAuthor(
            sortName: 'A',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 1000),
          ),
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 2000),
          ),
        ];
        final result = ReadarrBooksSorting.SIZE.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'C');
      });

      test('sorts descending by size on disk', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'A',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 1000),
          ),
          ReadarrAuthor(
            sortName: 'C',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 3000),
          ),
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 2000),
          ),
        ];
        final result = ReadarrBooksSorting.SIZE.sort(authors, false);

        expect(result[0].sortName, 'C');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'A');
      });

      test('uses alphabetical as tiebreaker for same size', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'Beta',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 1000),
          ),
          ReadarrAuthor(
            sortName: 'Alpha',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 1000),
          ),
        ];
        final result = ReadarrBooksSorting.SIZE.sort(authors, true);

        expect(result[0].sortName, 'Alpha');
        expect(result[1].sortName, 'Beta');
      });

      test('handles null statistics - treated as 0 size', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(sizeOnDisk: 1000),
          ),
          ReadarrAuthor(sortName: 'A'),
        ];
        final result = ReadarrBooksSorting.SIZE.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
      });
    });

    group('sort - BOOKS', () {
      test('sorts ascending by percent of books', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'C',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 75.0),
          ),
          ReadarrAuthor(
            sortName: 'A',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 25.0),
          ),
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 50.0),
          ),
        ];
        final result = ReadarrBooksSorting.BOOKS.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'C');
      });

      test('sorts descending by percent of books', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'A',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 25.0),
          ),
          ReadarrAuthor(
            sortName: 'C',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 75.0),
          ),
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 50.0),
          ),
        ];
        final result = ReadarrBooksSorting.BOOKS.sort(authors, false);

        expect(result[0].sortName, 'C');
        expect(result[1].sortName, 'B');
        expect(result[2].sortName, 'A');
      });

      test('uses alphabetical as tiebreaker for same percent', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'Beta',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 50.0),
          ),
          ReadarrAuthor(
            sortName: 'Alpha',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 50.0),
          ),
        ];
        final result = ReadarrBooksSorting.BOOKS.sort(authors, true);

        expect(result[0].sortName, 'Alpha');
        expect(result[1].sortName, 'Beta');
      });

      test('handles null statistics - treated as 0 percent', () {
        final authors = [
          ReadarrAuthor(
            sortName: 'B',
            statistics: ReadarrAuthorStatistics(percentOfBooks: 50.0),
          ),
          ReadarrAuthor(sortName: 'A'),
        ];
        final result = ReadarrBooksSorting.BOOKS.sort(authors, true);

        expect(result[0].sortName, 'A');
        expect(result[1].sortName, 'B');
      });
    });

    group('sort - empty and single element', () {
      test('sort handles empty list', () {
        final result = ReadarrBooksSorting.ALPHABETICAL.sort([], true);
        expect(result, isEmpty);
      });

      test('sort handles single element list', () {
        final authors = [ReadarrAuthor(sortName: 'Only Author')];
        final result = ReadarrBooksSorting.ALPHABETICAL.sort(authors, true);
        expect(result.length, 1);
        expect(result[0].sortName, 'Only Author');
      });
    });
  });
}
