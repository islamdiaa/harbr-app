import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/api/readarr/models/book/book_statistics.dart';
import 'package:harbr/api/readarr/models/book/edition.dart';
import 'package:harbr/api/readarr/models/author/author.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/readarr/core/extensions/readarr_book.dart';

void main() {
  group('ReadarrBookExtension', () {
    group('harbrTitle', () {
      test('returns title when present', () {
        final book = ReadarrBook(title: 'The Great Gatsby');
        expect(book.harbrTitle, 'The Great Gatsby');
      });

      test('returns emdash when title is null', () {
        final book = ReadarrBook();
        expect(book.harbrTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when title is empty', () {
        final book = ReadarrBook(title: '');
        expect(book.harbrTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrAuthorTitle', () {
      test('returns author name when present', () {
        final book = ReadarrBook(
          author: ReadarrAuthor(authorName: 'F. Scott Fitzgerald'),
        );
        expect(book.harbrAuthorTitle, 'F. Scott Fitzgerald');
      });

      test('returns emdash when author is null', () {
        final book = ReadarrBook();
        expect(book.harbrAuthorTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when authorName is null', () {
        final book = ReadarrBook(author: ReadarrAuthor());
        expect(book.harbrAuthorTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when authorName is empty', () {
        final book = ReadarrBook(
          author: ReadarrAuthor(authorName: ''),
        );
        expect(book.harbrAuthorTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrGenres', () {
      test('returns genres joined by newline when present', () {
        final book = ReadarrBook(genres: ['Fiction', 'Drama', 'Classic']);
        expect(book.harbrGenres, 'Fiction\nDrama\nClassic');
      });

      test('returns emdash when genres is null', () {
        final book = ReadarrBook();
        expect(book.harbrGenres, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when genres is empty list', () {
        final book = ReadarrBook(genres: []);
        expect(book.harbrGenres, HarbrUI.TEXT_EMDASH);
      });

      test('returns single genre when only one', () {
        final book = ReadarrBook(genres: ['Fiction']);
        expect(book.harbrGenres, 'Fiction');
      });
    });

    group('harbrPageCount', () {
      test('returns page count string when positive', () {
        final book = ReadarrBook(pageCount: 218);
        expect(book.harbrPageCount, '218 Pages');
      });

      test('returns emdash when pageCount is null', () {
        final book = ReadarrBook();
        expect(book.harbrPageCount, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when pageCount is zero', () {
        final book = ReadarrBook(pageCount: 0);
        expect(book.harbrPageCount, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when pageCount is negative', () {
        final book = ReadarrBook(pageCount: -1);
        expect(book.harbrPageCount, HarbrUI.TEXT_EMDASH);
      });

      test('returns page count for large numbers', () {
        final book = ReadarrBook(pageCount: 1500);
        expect(book.harbrPageCount, '1500 Pages');
      });
    });

    group('harbrEditionCount', () {
      test('returns edition count when editions present', () {
        final book = ReadarrBook(editions: [
          ReadarrEdition(id: 1),
          ReadarrEdition(id: 2),
          ReadarrEdition(id: 3),
        ]);
        expect(book.harbrEditionCount, '3');
      });

      test('returns 0 when editions is null', () {
        final book = ReadarrBook();
        expect(book.harbrEditionCount, '0');
      });

      test('returns 0 when editions is empty', () {
        final book = ReadarrBook(editions: []);
        expect(book.harbrEditionCount, '0');
      });
    });

    group('harbrIsGrabbed', () {
      test('returns true when grabbed is true', () {
        final book = ReadarrBook(grabbed: true);
        expect(book.harbrIsGrabbed, true);
      });

      test('returns false when grabbed is false', () {
        final book = ReadarrBook(grabbed: false);
        expect(book.harbrIsGrabbed, false);
      });

      test('returns false when grabbed is null', () {
        final book = ReadarrBook();
        expect(book.harbrIsGrabbed, false);
      });
    });

    group('harbrIsMonitored', () {
      test('returns true when monitored is true', () {
        final book = ReadarrBook(monitored: true);
        expect(book.harbrIsMonitored, true);
      });

      test('returns false when monitored is false', () {
        final book = ReadarrBook(monitored: false);
        expect(book.harbrIsMonitored, false);
      });

      test('returns false when monitored is null', () {
        final book = ReadarrBook();
        expect(book.harbrIsMonitored, false);
      });
    });

    group('harbrHasFile', () {
      test('returns true when bookFileCount > 0', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 1),
        );
        expect(book.harbrHasFile, true);
      });

      test('returns false when bookFileCount is 0', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 0),
        );
        expect(book.harbrHasFile, false);
      });

      test('returns false when statistics is null', () {
        final book = ReadarrBook();
        expect(book.harbrHasFile, false);
      });

      test('returns false when bookFileCount is null', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(),
        );
        expect(book.harbrHasFile, false);
      });

      test('returns true when bookFileCount is greater than 1', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 5),
        );
        expect(book.harbrHasFile, true);
      });
    });

    group('harbrFileStatus', () {
      // Note: .tr() returns the raw key when easy_localization is not initialized
      test('returns Downloaded status when bookFileCount > 0', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 1),
        );
        expect(book.harbrFileStatus, isNotEmpty);
        // Different result based on whether i18n is initialized
        final status = book.harbrFileStatus;
        expect(status == 'Downloaded' || status == 'readarr.Downloaded', true);
      });

      test('returns Grabbed status when no file but grabbed is true', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 0),
          grabbed: true,
        );
        final status = book.harbrFileStatus;
        expect(status == 'Grabbed' || status == 'readarr.Grabbed', true);
      });

      test('returns Missing status when no file and not grabbed', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 0),
          grabbed: false,
        );
        final status = book.harbrFileStatus;
        expect(status == 'Missing' || status == 'readarr.Missing', true);
      });

      test('returns Missing status when statistics is null and not grabbed', () {
        final book = ReadarrBook();
        final status = book.harbrFileStatus;
        expect(status == 'Missing' || status == 'readarr.Missing', true);
      });

      test('returns Downloaded status even when grabbed is also true', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(bookFileCount: 2),
          grabbed: true,
        );
        final status = book.harbrFileStatus;
        expect(status == 'Downloaded' || status == 'readarr.Downloaded', true);
      });

      test('returns Grabbed status when grabbed is true and statistics is null', () {
        final book = ReadarrBook(grabbed: true);
        final status = book.harbrFileStatus;
        expect(status == 'Grabbed' || status == 'readarr.Grabbed', true);
      });
    });

    group('harbrSizeOnDisk', () {
      test('returns emdash when size is 0', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 0),
        );
        expect(book.harbrSizeOnDisk, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when statistics is null', () {
        final book = ReadarrBook();
        expect(book.harbrSizeOnDisk, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when sizeOnDisk is null', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(),
        );
        expect(book.harbrSizeOnDisk, HarbrUI.TEXT_EMDASH);
      });

      test('returns bytes when size < 1024', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 500),
        );
        expect(book.harbrSizeOnDisk, '500 B');
      });

      test('returns KB when size is in KB range', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 2048),
        );
        expect(book.harbrSizeOnDisk, '2.0 KB');
      });

      test('returns MB when size is in MB range', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 5242880), // 5 MB
        );
        expect(book.harbrSizeOnDisk, '5.0 MB');
      });

      test('returns GB when size is in GB range', () {
        final book = ReadarrBook(
          statistics:
              ReadarrBookStatistics(sizeOnDisk: 1073741824), // 1 GB exactly
        );
        expect(book.harbrSizeOnDisk, '1.0 GB');
      });

      test('returns 1 B for size of 1', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 1),
        );
        expect(book.harbrSizeOnDisk, '1 B');
      });

      test('returns 1023 B for size of 1023', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 1023),
        );
        expect(book.harbrSizeOnDisk, '1023 B');
      });

      test('returns 1.0 KB for size of 1024', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 1024),
        );
        expect(book.harbrSizeOnDisk, '1.0 KB');
      });

      test('returns correct KB with decimal', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 1536), // 1.5 KB
        );
        expect(book.harbrSizeOnDisk, '1.5 KB');
      });

      test('returns 1.0 MB boundary', () {
        final book = ReadarrBook(
          statistics: ReadarrBookStatistics(sizeOnDisk: 1048576), // 1 MB
        );
        expect(book.harbrSizeOnDisk, '1.0 MB');
      });
    });

    group('clone', () {
      test('returns a deep copy with same values', () {
        final book = ReadarrBook(
          id: 1,
          title: 'Test Book',
          monitored: true,
          pageCount: 300,
          genres: ['Fiction'],
          grabbed: false,
          statistics: ReadarrBookStatistics(
            bookFileCount: 1,
            sizeOnDisk: 1024,
          ),
        );
        final cloned = book.clone();

        expect(cloned.id, book.id);
        expect(cloned.title, book.title);
        expect(cloned.monitored, book.monitored);
        expect(cloned.pageCount, book.pageCount);
        expect(cloned.genres, book.genres);
        expect(cloned.grabbed, book.grabbed);
        expect(cloned.statistics?.bookFileCount, book.statistics?.bookFileCount);
        expect(cloned.statistics?.sizeOnDisk, book.statistics?.sizeOnDisk);
      });

      test('modifying clone does not affect original', () {
        final book = ReadarrBook(
          id: 1,
          title: 'Original Title',
          monitored: true,
        );
        final cloned = book.clone();
        cloned.title = 'Modified Title';
        cloned.monitored = false;

        expect(book.title, 'Original Title');
        expect(book.monitored, true);
      });

      test('clone of empty book returns empty book', () {
        final book = ReadarrBook();
        final cloned = book.clone();

        expect(cloned.id, isNull);
        expect(cloned.title, isNull);
        expect(cloned.monitored, isNull);
      });
    });
  });
}
