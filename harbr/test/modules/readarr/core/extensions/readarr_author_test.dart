import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/api/readarr/models/author/author_statistics.dart';
import 'package:harbr/api/readarr/models/tag/tag.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/readarr/core/extensions/readarr_author.dart';

void main() {
  group('ReadarrAuthorExtension', () {
    group('harbrTitle', () {
      test('returns author name when present', () {
        final author = ReadarrAuthor(authorName: 'Stephen King');
        expect(author.harbrTitle, 'Stephen King');
      });

      test('returns emdash when authorName is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when authorName is empty', () {
        final author = ReadarrAuthor(authorName: '');
        expect(author.harbrTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrSortTitle', () {
      test('returns sort name when present', () {
        final author = ReadarrAuthor(sortName: 'king, stephen');
        expect(author.harbrSortTitle, 'king, stephen');
      });

      test('returns emdash when sortName is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrSortTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when sortName is empty', () {
        final author = ReadarrAuthor(sortName: '');
        expect(author.harbrSortTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrGenres', () {
      test('returns genres joined by newline when present', () {
        final author = ReadarrAuthor(genres: ['Horror', 'Thriller']);
        expect(author.harbrGenres, 'Horror\nThriller');
      });

      test('returns genres joined by newline for three genres', () {
        final author =
            ReadarrAuthor(genres: ['Horror', 'Thriller', 'Mystery']);
        expect(author.harbrGenres, 'Horror\nThriller\nMystery');
      });

      test('returns emdash when genres is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrGenres, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when genres is empty', () {
        final author = ReadarrAuthor(genres: []);
        expect(author.harbrGenres, HarbrUI.TEXT_EMDASH);
      });

      test('returns single genre when only one', () {
        final author = ReadarrAuthor(genres: ['Fiction']);
        expect(author.harbrGenres, 'Fiction');
      });
    });

    group('harbrBookFileCount', () {
      test('returns file count when statistics present', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(bookFileCount: 5),
        );
        expect(author.harbrBookFileCount, '5');
      });

      test('returns 0 when statistics is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrBookFileCount, '0');
      });

      test('returns 0 when bookFileCount is null', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(),
        );
        expect(author.harbrBookFileCount, '0');
      });
    });

    group('harbrBookCount', () {
      test('returns book count when statistics present', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(bookCount: 10),
        );
        expect(author.harbrBookCount, '10');
      });

      test('returns 0 when statistics is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrBookCount, '0');
      });

      test('returns 0 when bookCount is null', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(),
        );
        expect(author.harbrBookCount, '0');
      });
    });

    group('harbrTotalBookCount', () {
      test('returns total book count when present', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(totalBookCount: 25),
        );
        expect(author.harbrTotalBookCount, '25');
      });

      test('returns 0 when statistics is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrTotalBookCount, '0');
      });

      test('returns 0 when totalBookCount is null', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(),
        );
        expect(author.harbrTotalBookCount, '0');
      });
    });

    group('harbrPercentOfBooks', () {
      test('returns formatted percent when present', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(percentOfBooks: 75.5),
        );
        expect(author.harbrPercentOfBooks, '76%');
      });

      test('returns 0% when statistics is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrPercentOfBooks, '0%');
      });

      test('returns 0% when percentOfBooks is null', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(),
        );
        expect(author.harbrPercentOfBooks, '0%');
      });

      test('returns 100% for full completion', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(percentOfBooks: 100.0),
        );
        expect(author.harbrPercentOfBooks, '100%');
      });

      test('rounds to nearest integer', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(percentOfBooks: 33.33),
        );
        expect(author.harbrPercentOfBooks, '33%');
      });
    });

    group('harbrBookProgress', () {
      test('returns formatted progress string', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(
            bookFileCount: 5,
            bookCount: 10,
            percentOfBooks: 50.0,
          ),
        );
        expect(author.harbrBookProgress, '5/10 (50%)');
      });

      test('returns 0/0 (0%) when statistics is null', () {
        final author = ReadarrAuthor();
        expect(author.harbrBookProgress, '0/0 (0%)');
      });

      test('returns 0/0 (0%) when all stats are null', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(),
        );
        expect(author.harbrBookProgress, '0/0 (0%)');
      });

      test('rounds percent in progress string', () {
        final author = ReadarrAuthor(
          statistics: ReadarrAuthorStatistics(
            bookFileCount: 1,
            bookCount: 3,
            percentOfBooks: 33.33,
          ),
        );
        expect(author.harbrBookProgress, '1/3 (33%)');
      });
    });

    group('harbrTags', () {
      test('returns tags joined by newline when present', () {
        final author = ReadarrAuthor();
        final tags = [
          ReadarrTag(id: 1, label: 'favorite'),
          ReadarrTag(id: 2, label: 'must-read'),
        ];
        expect(author.harbrTags(tags), 'favorite\nmust-read');
      });

      test('returns emdash when tags list is empty', () {
        final author = ReadarrAuthor();
        expect(author.harbrTags([]), HarbrUI.TEXT_EMDASH);
      });

      test('returns single tag when only one', () {
        final author = ReadarrAuthor();
        final tags = [ReadarrTag(id: 1, label: 'fiction')];
        expect(author.harbrTags(tags), 'fiction');
      });
    });

    group('clone', () {
      test('returns a deep copy with same values', () {
        final author = ReadarrAuthor(
          id: 1,
          authorName: 'Test Author',
          sortName: 'author, test',
          monitored: true,
          statistics: ReadarrAuthorStatistics(
            bookFileCount: 3,
            bookCount: 5,
            sizeOnDisk: 1024000,
          ),
        );
        final cloned = author.clone();

        expect(cloned.id, author.id);
        expect(cloned.authorName, author.authorName);
        expect(cloned.sortName, author.sortName);
        expect(cloned.monitored, author.monitored);
        expect(
          cloned.statistics?.bookFileCount,
          author.statistics?.bookFileCount,
        );
      });

      test('modifying clone does not affect original', () {
        final author = ReadarrAuthor(
          id: 1,
          authorName: 'Original Name',
        );
        final cloned = author.clone();
        cloned.authorName = 'Modified Name';

        expect(author.authorName, 'Original Name');
      });
    });
  });
}
