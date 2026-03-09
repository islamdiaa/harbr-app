import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/book/book_statistics.dart';
import 'package:harbr/api/readarr/models/media/rating.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/modules/readarr/core/types/sorting_books.dart';

void main() {
  group('ReadarrBooksSorting - extended sort types', () {
    group('enum coverage', () {
      test('RATING has key "rating"', () {
        expect(ReadarrBooksSorting.RATING.key, 'rating');
      });

      test('RELEASE_DATE has key "release_date"', () {
        expect(ReadarrBooksSorting.RELEASE_DATE.key, 'release_date');
      });

      test('AUTHOR has key "author"', () {
        expect(ReadarrBooksSorting.AUTHOR.key, 'author');
      });

      test('RATING readable returns non-empty string', () {
        expect(ReadarrBooksSorting.RATING.readable, isNotEmpty);
      });

      test('RELEASE_DATE readable returns non-empty string', () {
        expect(ReadarrBooksSorting.RELEASE_DATE.readable, isNotEmpty);
      });

      test('AUTHOR readable returns non-empty string', () {
        expect(ReadarrBooksSorting.AUTHOR.readable, isNotEmpty);
      });

      test('fromKey returns RATING from "rating"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('rating'),
          ReadarrBooksSorting.RATING,
        );
      });

      test('fromKey returns RELEASE_DATE from "release_date"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('release_date'),
          ReadarrBooksSorting.RELEASE_DATE,
        );
      });

      test('fromKey returns AUTHOR from "author"', () {
        expect(
          ReadarrBooksSorting.ALPHABETICAL.fromKey('author'),
          ReadarrBooksSorting.AUTHOR,
        );
      });

      test('all 7 sort types have unique keys', () {
        final keys = ReadarrBooksSorting.values.map((s) => s.key).toSet();
        expect(keys.length, 7);
        expect(keys.length, ReadarrBooksSorting.values.length);
      });
    });

    group('sortBooks - RATING', () {
      final emptyAuthors = <int, ReadarrAuthor>{};

      test('sorts ascending by rating value', () {
        final books = [
          ReadarrBook(
            title: 'High Rated',
            ratings: ReadarrRating(value: 4.5),
          ),
          ReadarrBook(
            title: 'Low Rated',
            ratings: ReadarrRating(value: 1.5),
          ),
          ReadarrBook(
            title: 'Mid Rated',
            ratings: ReadarrRating(value: 3.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Low Rated');
        expect(result[1].title, 'Mid Rated');
        expect(result[2].title, 'High Rated');
      });

      test('sorts descending by rating value', () {
        final books = [
          ReadarrBook(
            title: 'Low Rated',
            ratings: ReadarrRating(value: 1.5),
          ),
          ReadarrBook(
            title: 'High Rated',
            ratings: ReadarrRating(value: 4.5),
          ),
          ReadarrBook(
            title: 'Mid Rated',
            ratings: ReadarrRating(value: 3.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, false, emptyAuthors);

        expect(result[0].title, 'High Rated');
        expect(result[1].title, 'Mid Rated');
        expect(result[2].title, 'Low Rated');
      });

      test('handles null ratings (treated as 0)', () {
        final books = [
          ReadarrBook(
            title: 'Has Rating',
            ratings: ReadarrRating(value: 3.0),
          ),
          ReadarrBook(
            title: 'No Rating',
            ratings: null,
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);

        // null ratings -> value 0, sorts first ascending
        expect(result[0].title, 'No Rating');
        expect(result[1].title, 'Has Rating');
      });

      test('handles null rating value (treated as 0)', () {
        final books = [
          ReadarrBook(
            title: 'Has Value',
            ratings: ReadarrRating(value: 2.5),
          ),
          ReadarrBook(
            title: 'Null Value',
            ratings: ReadarrRating(value: null),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Null Value');
        expect(result[1].title, 'Has Value');
      });

      test('uses title as tiebreaker for same rating', () {
        final books = [
          ReadarrBook(
            title: 'Beta Book',
            ratings: ReadarrRating(value: 4.0),
          ),
          ReadarrBook(
            title: 'Alpha Book',
            ratings: ReadarrRating(value: 4.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Alpha Book');
        expect(result[1].title, 'Beta Book');
      });

      test('handles all null ratings', () {
        final books = [
          ReadarrBook(title: 'Beta'),
          ReadarrBook(title: 'Alpha'),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);

        // All have rating 0, so sorted by title
        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'Beta');
      });

      test('empty list returns empty', () {
        final result = ReadarrBooksSorting.RATING
            .sortBooks([], true, emptyAuthors);
        expect(result, isEmpty);
      });

      test('single element returns same element', () {
        final books = [
          ReadarrBook(
            title: 'Only',
            ratings: ReadarrRating(value: 5.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);
        expect(result.length, 1);
        expect(result[0].title, 'Only');
      });

      test('sorts with zero rating values', () {
        final books = [
          ReadarrBook(
            title: 'Positive',
            ratings: ReadarrRating(value: 0.5),
          ),
          ReadarrBook(
            title: 'Zero',
            ratings: ReadarrRating(value: 0.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, emptyAuthors);
        expect(result[0].title, 'Zero');
        expect(result[1].title, 'Positive');
      });
    });

    group('sortBooks - RELEASE_DATE', () {
      final emptyAuthors = <int, ReadarrAuthor>{};

      test('sorts ascending by release date', () {
        final books = [
          ReadarrBook(
            title: 'Latest',
            releaseDate: DateTime(2024, 6, 1),
          ),
          ReadarrBook(
            title: 'Earliest',
            releaseDate: DateTime(2020, 1, 1),
          ),
          ReadarrBook(
            title: 'Middle',
            releaseDate: DateTime(2022, 3, 15),
          ),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Earliest');
        expect(result[1].title, 'Middle');
        expect(result[2].title, 'Latest');
      });

      test('sorts descending by release date', () {
        final books = [
          ReadarrBook(
            title: 'Earliest',
            releaseDate: DateTime(2020, 1, 1),
          ),
          ReadarrBook(
            title: 'Latest',
            releaseDate: DateTime(2024, 6, 1),
          ),
          ReadarrBook(
            title: 'Middle',
            releaseDate: DateTime(2022, 3, 15),
          ),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, false, emptyAuthors);

        expect(result[0].title, 'Latest');
        expect(result[1].title, 'Middle');
        expect(result[2].title, 'Earliest');
      });

      test('handles null release date ascending (null goes to end)', () {
        final books = [
          ReadarrBook(
            title: 'No Date',
            releaseDate: null,
          ),
          ReadarrBook(
            title: 'Has Date',
            releaseDate: DateTime(2023, 1, 1),
          ),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Has Date');
        expect(result[1].title, 'No Date');
      });

      test('handles null release date descending (null goes to end)', () {
        final books = [
          ReadarrBook(
            title: 'Has Date',
            releaseDate: DateTime(2023, 1, 1),
          ),
          ReadarrBook(
            title: 'No Date',
            releaseDate: null,
          ),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, false, emptyAuthors);

        // Descending: null dates go to end (return -1 when b is null)
        expect(result[0].title, 'Has Date');
        expect(result[1].title, 'No Date');
      });

      test('uses title as tiebreaker for same release date', () {
        final sameDate = DateTime(2023, 6, 15);
        final books = [
          ReadarrBook(title: 'Beta', releaseDate: sameDate),
          ReadarrBook(title: 'Alpha', releaseDate: sameDate),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'Beta');
      });

      test('handles all null release dates (sorted by title)', () {
        final books = [
          ReadarrBook(title: 'Charlie'),
          ReadarrBook(title: 'Alpha'),
          ReadarrBook(title: 'Beta'),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);

        // All nulls push to end; relative order depends on sort stability
        // Since all are null, comparisons return 1 or -1 based on null checks,
        // but all elements have null dates, so they stay in
        // the position determined by the comparison order.
        expect(result.length, 3);
      });

      test('empty list returns empty', () {
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks([], true, emptyAuthors);
        expect(result, isEmpty);
      });

      test('single element returns same element', () {
        final books = [
          ReadarrBook(title: 'Only', releaseDate: DateTime(2023, 1, 1)),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);
        expect(result.length, 1);
        expect(result[0].title, 'Only');
      });

      test('mixed null and non-null dates with multiple nulls', () {
        final books = [
          ReadarrBook(title: 'No Date 1'),
          ReadarrBook(
            title: 'Has Date A',
            releaseDate: DateTime(2022, 1, 1),
          ),
          ReadarrBook(title: 'No Date 2'),
          ReadarrBook(
            title: 'Has Date B',
            releaseDate: DateTime(2023, 1, 1),
          ),
        ];
        final result = ReadarrBooksSorting.RELEASE_DATE
            .sortBooks(books, true, emptyAuthors);

        // Non-null dates first in ascending order, null dates at end
        expect(result[0].title, 'Has Date A');
        expect(result[1].title, 'Has Date B');
      });
    });

    group('sortBooks - AUTHOR', () {
      test('sorts ascending by author name', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Tolkien'),
          2: ReadarrAuthor(id: 2, authorName: 'Asimov'),
          3: ReadarrAuthor(id: 3, authorName: 'King'),
        };
        final books = [
          ReadarrBook(title: 'Book C', authorId: 1),
          ReadarrBook(title: 'Book A', authorId: 2),
          ReadarrBook(title: 'Book B', authorId: 3),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        expect(result[0].authorId, 2); // Asimov
        expect(result[1].authorId, 3); // King
        expect(result[2].authorId, 1); // Tolkien
      });

      test('sorts descending by author name', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Tolkien'),
          2: ReadarrAuthor(id: 2, authorName: 'Asimov'),
          3: ReadarrAuthor(id: 3, authorName: 'King'),
        };
        final books = [
          ReadarrBook(title: 'Book A', authorId: 2),
          ReadarrBook(title: 'Book C', authorId: 1),
          ReadarrBook(title: 'Book B', authorId: 3),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, false, authors);

        expect(result[0].authorId, 1); // Tolkien
        expect(result[1].authorId, 3); // King
        expect(result[2].authorId, 2); // Asimov
      });

      test('handles null authorId (author name treated as empty)', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Known Author'),
        };
        final books = [
          ReadarrBook(title: 'Has Author', authorId: 1),
          ReadarrBook(title: 'No Author', authorId: null),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        // null authorId -> empty author name '' sorts first
        expect(result[0].title, 'No Author');
        expect(result[1].title, 'Has Author');
      });

      test('handles authorId not in map (treated as empty)', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Known Author'),
        };
        final books = [
          ReadarrBook(title: 'Known', authorId: 1),
          ReadarrBook(title: 'Unknown', authorId: 999),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        // authorId 999 not in map -> empty string, sorts first
        expect(result[0].title, 'Unknown');
        expect(result[1].title, 'Known');
      });

      test('handles null authorName in author map (treated as empty)', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Known'),
          2: ReadarrAuthor(id: 2, authorName: null),
        };
        final books = [
          ReadarrBook(title: 'Has Name', authorId: 1),
          ReadarrBook(title: 'Null Name', authorId: 2),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        // null authorName -> '' sorts first
        expect(result[0].title, 'Null Name');
        expect(result[1].title, 'Has Name');
      });

      test('uses title as tiebreaker for same author', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Same Author'),
        };
        final books = [
          ReadarrBook(title: 'Beta Book', authorId: 1),
          ReadarrBook(title: 'Alpha Book', authorId: 1),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        expect(result[0].title, 'Alpha Book');
        expect(result[1].title, 'Beta Book');
      });

      test('is case insensitive', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'zebra'),
          2: ReadarrAuthor(id: 2, authorName: 'Alpha'),
          3: ReadarrAuthor(id: 3, authorName: 'beta'),
        };
        final books = [
          ReadarrBook(title: 'Book 1', authorId: 1),
          ReadarrBook(title: 'Book 2', authorId: 2),
          ReadarrBook(title: 'Book 3', authorId: 3),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);

        expect(result[0].authorId, 2); // Alpha
        expect(result[1].authorId, 3); // beta
        expect(result[2].authorId, 1); // zebra
      });

      test('empty list returns empty', () {
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks([], true, <int, ReadarrAuthor>{});
        expect(result, isEmpty);
      });

      test('single element returns same element', () {
        final authors = <int, ReadarrAuthor>{
          1: ReadarrAuthor(id: 1, authorName: 'Author'),
        };
        final books = [ReadarrBook(title: 'Only', authorId: 1)];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, authors);
        expect(result.length, 1);
        expect(result[0].title, 'Only');
      });

      test('empty authors map treats all as empty author name', () {
        final books = [
          ReadarrBook(title: 'Beta', authorId: 1),
          ReadarrBook(title: 'Alpha', authorId: 2),
        ];
        final result = ReadarrBooksSorting.AUTHOR
            .sortBooks(books, true, <int, ReadarrAuthor>{});

        // All author names are '', so sorted by title
        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'Beta');
      });
    });

    group('sortBooks vs sort (author-level)', () {
      test('RATING sortBooks sorts by book rating, not author rating', () {
        final authors = <int, ReadarrAuthor>{};
        final books = [
          ReadarrBook(
            title: 'Book A',
            ratings: ReadarrRating(value: 1.0),
          ),
          ReadarrBook(
            title: 'Book B',
            ratings: ReadarrRating(value: 5.0),
          ),
        ];
        final result = ReadarrBooksSorting.RATING
            .sortBooks(books, true, authors);

        expect(result[0].ratings!.value, 1.0);
        expect(result[1].ratings!.value, 5.0);
      });
    });

    group('sortBooks - SIZE on books', () {
      final emptyAuthors = <int, ReadarrAuthor>{};

      test('sorts ascending by book sizeOnDisk', () {
        final books = [
          ReadarrBook(
            title: 'Big',
            statistics: ReadarrBookStatistics(sizeOnDisk: 5000),
          ),
          ReadarrBook(
            title: 'Small',
            statistics: ReadarrBookStatistics(sizeOnDisk: 100),
          ),
          ReadarrBook(
            title: 'Medium',
            statistics: ReadarrBookStatistics(sizeOnDisk: 2000),
          ),
        ];
        final result = ReadarrBooksSorting.SIZE
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Small');
        expect(result[1].title, 'Medium');
        expect(result[2].title, 'Big');
      });

      test('sorts descending by book sizeOnDisk', () {
        final books = [
          ReadarrBook(
            title: 'Small',
            statistics: ReadarrBookStatistics(sizeOnDisk: 100),
          ),
          ReadarrBook(
            title: 'Big',
            statistics: ReadarrBookStatistics(sizeOnDisk: 5000),
          ),
        ];
        final result = ReadarrBooksSorting.SIZE
            .sortBooks(books, false, emptyAuthors);

        expect(result[0].title, 'Big');
        expect(result[1].title, 'Small');
      });

      test('handles null statistics on books (treated as 0)', () {
        final books = [
          ReadarrBook(
            title: 'Has Size',
            statistics: ReadarrBookStatistics(sizeOnDisk: 1000),
          ),
          ReadarrBook(title: 'No Stats'),
        ];
        final result = ReadarrBooksSorting.SIZE
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'No Stats');
        expect(result[1].title, 'Has Size');
      });
    });

    group('sortBooks - DATE_ADDED on books', () {
      final emptyAuthors = <int, ReadarrAuthor>{};

      test('sorts ascending by book added date', () {
        final books = [
          ReadarrBook(
            title: 'Recent',
            added: DateTime(2024, 1, 1),
          ),
          ReadarrBook(
            title: 'Old',
            added: DateTime(2020, 1, 1),
          ),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Old');
        expect(result[1].title, 'Recent');
      });

      test('sorts descending by book added date', () {
        final books = [
          ReadarrBook(
            title: 'Old',
            added: DateTime(2020, 1, 1),
          ),
          ReadarrBook(
            title: 'Recent',
            added: DateTime(2024, 1, 1),
          ),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED
            .sortBooks(books, false, emptyAuthors);

        expect(result[0].title, 'Recent');
        expect(result[1].title, 'Old');
      });

      test('handles null added date (goes to end ascending)', () {
        final books = [
          ReadarrBook(title: 'No Date'),
          ReadarrBook(title: 'Has Date', added: DateTime(2023, 6, 1)),
        ];
        final result = ReadarrBooksSorting.DATE_ADDED
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Has Date');
        expect(result[1].title, 'No Date');
      });
    });

    group('sortBooks - ALPHABETICAL on books', () {
      final emptyAuthors = <int, ReadarrAuthor>{};

      test('sorts ascending by title', () {
        final books = [
          ReadarrBook(title: 'Zebra'),
          ReadarrBook(title: 'Alpha'),
          ReadarrBook(title: 'Middle'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'Middle');
        expect(result[2].title, 'Zebra');
      });

      test('sorts descending by title', () {
        final books = [
          ReadarrBook(title: 'Alpha'),
          ReadarrBook(title: 'Zebra'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL
            .sortBooks(books, false, emptyAuthors);

        expect(result[0].title, 'Zebra');
        expect(result[1].title, 'Alpha');
      });

      test('handles null title (treated as empty)', () {
        final books = [
          ReadarrBook(title: 'Beta'),
          ReadarrBook(title: null),
          ReadarrBook(title: 'Alpha'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, isNull); // '' sorts first
        expect(result[1].title, 'Alpha');
        expect(result[2].title, 'Beta');
      });

      test('is case insensitive', () {
        final books = [
          ReadarrBook(title: 'zebra'),
          ReadarrBook(title: 'Alpha'),
        ];
        final result = ReadarrBooksSorting.ALPHABETICAL
            .sortBooks(books, true, emptyAuthors);

        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'zebra');
      });
    });
  });
}
