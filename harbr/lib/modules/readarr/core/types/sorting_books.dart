import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

part 'sorting_books.g.dart';

@HiveType(typeId: 31, adapterName: 'ReadarrBooksSortingAdapter')
enum ReadarrBooksSorting {
  @HiveField(0)
  ALPHABETICAL,
  @HiveField(1)
  DATE_ADDED,
  @HiveField(2)
  SIZE,
  @HiveField(3)
  BOOKS,
  @HiveField(4)
  RATING,
  @HiveField(5)
  RELEASE_DATE,
  @HiveField(6)
  AUTHOR,
}

extension ReadarrBooksSortingExtension on ReadarrBooksSorting {
  String get key {
    switch (this) {
      case ReadarrBooksSorting.ALPHABETICAL:
        return 'abc';
      case ReadarrBooksSorting.DATE_ADDED:
        return 'date_added';
      case ReadarrBooksSorting.SIZE:
        return 'size';
      case ReadarrBooksSorting.BOOKS:
        return 'books';
      case ReadarrBooksSorting.RATING:
        return 'rating';
      case ReadarrBooksSorting.RELEASE_DATE:
        return 'release_date';
      case ReadarrBooksSorting.AUTHOR:
        return 'author';
    }
  }

  String get readable {
    switch (this) {
      case ReadarrBooksSorting.ALPHABETICAL:
        return 'readarr.Alphabetical'.tr();
      case ReadarrBooksSorting.DATE_ADDED:
        return 'readarr.DateAdded'.tr();
      case ReadarrBooksSorting.SIZE:
        return 'readarr.Size'.tr();
      case ReadarrBooksSorting.BOOKS:
        return 'readarr.Books'.tr();
      case ReadarrBooksSorting.RATING:
        return 'readarr.Rating'.tr();
      case ReadarrBooksSorting.RELEASE_DATE:
        return 'readarr.ReleaseDate'.tr();
      case ReadarrBooksSorting.AUTHOR:
        return 'readarr.Author'.tr();
    }
  }

  String value(ReadarrAuthor author) {
    switch (this) {
      case ReadarrBooksSorting.ALPHABETICAL:
        return author.harbrBookProgress;
      case ReadarrBooksSorting.DATE_ADDED:
        return author.harbrDateAdded;
      case ReadarrBooksSorting.SIZE:
        return author.harbrSizeOnDisk;
      case ReadarrBooksSorting.BOOKS:
        return author.harbrBookProgress;
      case ReadarrBooksSorting.RATING:
        return author.harbrBookProgress;
      case ReadarrBooksSorting.RELEASE_DATE:
        return author.harbrDateAdded;
      case ReadarrBooksSorting.AUTHOR:
        return author.harbrTitle;
    }
  }

  ReadarrBooksSorting? fromKey(String? key) {
    switch (key) {
      case 'abc':
        return ReadarrBooksSorting.ALPHABETICAL;
      case 'date_added':
        return ReadarrBooksSorting.DATE_ADDED;
      case 'size':
        return ReadarrBooksSorting.SIZE;
      case 'books':
        return ReadarrBooksSorting.BOOKS;
      case 'rating':
        return ReadarrBooksSorting.RATING;
      case 'release_date':
        return ReadarrBooksSorting.RELEASE_DATE;
      case 'author':
        return ReadarrBooksSorting.AUTHOR;
      default:
        return null;
    }
  }

  List<ReadarrAuthor> sort(List<ReadarrAuthor> data, bool ascending) =>
      _Sorter().byType(data, this, ascending);

  List<ReadarrBook> sortBooks(
    List<ReadarrBook> data,
    bool ascending,
    Map<int, ReadarrAuthor> authors,
  ) =>
      _BookSorter().byType(data, this, ascending, authors);
}

class _Sorter {
  List<ReadarrAuthor> byType(
    List<ReadarrAuthor> data,
    ReadarrBooksSorting type,
    bool ascending,
  ) {
    switch (type) {
      case ReadarrBooksSorting.ALPHABETICAL:
        return _alphabetical(data, ascending);
      case ReadarrBooksSorting.DATE_ADDED:
        return _dateAdded(data, ascending);
      case ReadarrBooksSorting.SIZE:
        return _size(data, ascending);
      case ReadarrBooksSorting.BOOKS:
        return _books(data, ascending);
      case ReadarrBooksSorting.RATING:
        return _alphabetical(data, ascending);
      case ReadarrBooksSorting.RELEASE_DATE:
        return _dateAdded(data, ascending);
      case ReadarrBooksSorting.AUTHOR:
        return _alphabetical(data, ascending);
    }
  }

  List<ReadarrAuthor> _alphabetical(
      List<ReadarrAuthor> authors, bool ascending) {
    ascending
        ? authors.sort((a, b) => (a.sortName ?? '')
            .toLowerCase()
            .compareTo((b.sortName ?? '').toLowerCase()))
        : authors.sort((a, b) => (b.sortName ?? '')
            .toLowerCase()
            .compareTo((a.sortName ?? '').toLowerCase()));
    return authors;
  }

  List<ReadarrAuthor> _dateAdded(List<ReadarrAuthor> authors, bool ascending) {
    authors.sort((a, b) {
      if (ascending) {
        if (a.added == null) return 1;
        if (b.added == null) return -1;
        int _comparison = a.added!.compareTo(b.added!);
        return _comparison == 0
            ? (a.sortName ?? '')
                .toLowerCase()
                .compareTo((b.sortName ?? '').toLowerCase())
            : _comparison;
      } else {
        if (b.added == null) return -1;
        if (a.added == null) return 1;
        int _comparison = b.added!.compareTo(a.added!);
        return _comparison == 0
            ? (a.sortName ?? '')
                .toLowerCase()
                .compareTo((b.sortName ?? '').toLowerCase())
            : _comparison;
      }
    });
    return authors;
  }

  List<ReadarrAuthor> _size(List<ReadarrAuthor> authors, bool ascending) {
    authors.sort((a, b) {
      int _comparison = ascending
          ? (a.statistics?.sizeOnDisk ?? 0)
              .compareTo(b.statistics?.sizeOnDisk ?? 0)
          : (b.statistics?.sizeOnDisk ?? 0)
              .compareTo(a.statistics?.sizeOnDisk ?? 0);
      return _comparison == 0
          ? (a.sortName ?? '')
              .toLowerCase()
              .compareTo((b.sortName ?? '').toLowerCase())
          : _comparison;
    });
    return authors;
  }

  List<ReadarrAuthor> _books(List<ReadarrAuthor> authors, bool ascending) {
    authors.sort((a, b) {
      int _comparison = ascending
          ? (a.statistics?.percentOfBooks ?? 0)
              .compareTo(b.statistics?.percentOfBooks ?? 0)
          : (b.statistics?.percentOfBooks ?? 0)
              .compareTo(a.statistics?.percentOfBooks ?? 0);
      return _comparison == 0
          ? (a.sortName ?? '')
              .toLowerCase()
              .compareTo((b.sortName ?? '').toLowerCase())
          : _comparison;
    });
    return authors;
  }
}

class _BookSorter {
  List<ReadarrBook> byType(
    List<ReadarrBook> data,
    ReadarrBooksSorting type,
    bool ascending,
    Map<int, ReadarrAuthor> authors,
  ) {
    switch (type) {
      case ReadarrBooksSorting.ALPHABETICAL:
        return _alphabetical(data, ascending);
      case ReadarrBooksSorting.DATE_ADDED:
        return _dateAdded(data, ascending);
      case ReadarrBooksSorting.SIZE:
        return _size(data, ascending);
      case ReadarrBooksSorting.BOOKS:
        return _alphabetical(data, ascending);
      case ReadarrBooksSorting.RATING:
        return _rating(data, ascending);
      case ReadarrBooksSorting.RELEASE_DATE:
        return _releaseDate(data, ascending);
      case ReadarrBooksSorting.AUTHOR:
        return _author(data, ascending, authors);
    }
  }

  List<ReadarrBook> _alphabetical(List<ReadarrBook> books, bool ascending) {
    ascending
        ? books.sort((a, b) => (a.title ?? '')
            .toLowerCase()
            .compareTo((b.title ?? '').toLowerCase()))
        : books.sort((a, b) => (b.title ?? '')
            .toLowerCase()
            .compareTo((a.title ?? '').toLowerCase()));
    return books;
  }

  List<ReadarrBook> _dateAdded(List<ReadarrBook> books, bool ascending) {
    books.sort((a, b) {
      if (ascending) {
        if (a.added == null) return 1;
        if (b.added == null) return -1;
        int comparison = a.added!.compareTo(b.added!);
        return comparison == 0
            ? (a.title ?? '')
                .toLowerCase()
                .compareTo((b.title ?? '').toLowerCase())
            : comparison;
      } else {
        if (b.added == null) return -1;
        if (a.added == null) return 1;
        int comparison = b.added!.compareTo(a.added!);
        return comparison == 0
            ? (a.title ?? '')
                .toLowerCase()
                .compareTo((b.title ?? '').toLowerCase())
            : comparison;
      }
    });
    return books;
  }

  List<ReadarrBook> _size(List<ReadarrBook> books, bool ascending) {
    books.sort((a, b) {
      int comparison = ascending
          ? (a.statistics?.sizeOnDisk ?? 0)
              .compareTo(b.statistics?.sizeOnDisk ?? 0)
          : (b.statistics?.sizeOnDisk ?? 0)
              .compareTo(a.statistics?.sizeOnDisk ?? 0);
      return comparison == 0
          ? (a.title ?? '')
              .toLowerCase()
              .compareTo((b.title ?? '').toLowerCase())
          : comparison;
    });
    return books;
  }

  List<ReadarrBook> _rating(List<ReadarrBook> books, bool ascending) {
    books.sort((a, b) {
      int comparison = ascending
          ? (a.ratings?.value ?? 0).compareTo(b.ratings?.value ?? 0)
          : (b.ratings?.value ?? 0).compareTo(a.ratings?.value ?? 0);
      return comparison == 0
          ? (a.title ?? '')
              .toLowerCase()
              .compareTo((b.title ?? '').toLowerCase())
          : comparison;
    });
    return books;
  }

  List<ReadarrBook> _releaseDate(List<ReadarrBook> books, bool ascending) {
    books.sort((a, b) {
      if (ascending) {
        if (a.releaseDate == null) return 1;
        if (b.releaseDate == null) return -1;
        int comparison = a.releaseDate!.compareTo(b.releaseDate!);
        return comparison == 0
            ? (a.title ?? '')
                .toLowerCase()
                .compareTo((b.title ?? '').toLowerCase())
            : comparison;
      } else {
        if (b.releaseDate == null) return -1;
        if (a.releaseDate == null) return 1;
        int comparison = b.releaseDate!.compareTo(a.releaseDate!);
        return comparison == 0
            ? (a.title ?? '')
                .toLowerCase()
                .compareTo((b.title ?? '').toLowerCase())
            : comparison;
      }
    });
    return books;
  }

  List<ReadarrBook> _author(
    List<ReadarrBook> books,
    bool ascending,
    Map<int, ReadarrAuthor> authors,
  ) {
    books.sort((a, b) {
      String authorA = '';
      String authorB = '';
      if (a.authorId != null && authors.containsKey(a.authorId)) {
        authorA = authors[a.authorId]!.authorName?.toLowerCase() ?? '';
      }
      if (b.authorId != null && authors.containsKey(b.authorId)) {
        authorB = authors[b.authorId]!.authorName?.toLowerCase() ?? '';
      }
      int comparison =
          ascending ? authorA.compareTo(authorB) : authorB.compareTo(authorA);
      return comparison == 0
          ? (a.title ?? '')
              .toLowerCase()
              .compareTo((b.title ?? '').toLowerCase())
          : comparison;
    });
    return books;
  }
}
