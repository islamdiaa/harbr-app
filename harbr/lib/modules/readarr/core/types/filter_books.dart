import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

part 'filter_books.g.dart';

@HiveType(typeId: 30, adapterName: 'ReadarrBooksFilterAdapter')
enum ReadarrBooksFilter {
  @HiveField(0)
  ALL,
  @HiveField(1)
  MONITORED,
  @HiveField(2)
  UNMONITORED,
  @HiveField(3)
  MISSING,
}

extension ReadarrBooksFilterExtension on ReadarrBooksFilter {
  String get key {
    switch (this) {
      case ReadarrBooksFilter.ALL:
        return 'all';
      case ReadarrBooksFilter.MONITORED:
        return 'monitored';
      case ReadarrBooksFilter.UNMONITORED:
        return 'unmonitored';
      case ReadarrBooksFilter.MISSING:
        return 'missing';
    }
  }

  ReadarrBooksFilter? fromKey(String? key) {
    switch (key) {
      case 'all':
        return ReadarrBooksFilter.ALL;
      case 'monitored':
        return ReadarrBooksFilter.MONITORED;
      case 'unmonitored':
        return ReadarrBooksFilter.UNMONITORED;
      case 'missing':
        return ReadarrBooksFilter.MISSING;
      default:
        return null;
    }
  }

  String get readable {
    switch (this) {
      case ReadarrBooksFilter.ALL:
        return 'readarr.All'.tr();
      case ReadarrBooksFilter.MONITORED:
        return 'readarr.Monitored'.tr();
      case ReadarrBooksFilter.UNMONITORED:
        return 'readarr.Unmonitored'.tr();
      case ReadarrBooksFilter.MISSING:
        return 'readarr.Missing'.tr();
    }
  }

  List<ReadarrBook> filter(List<ReadarrBook> books) =>
      _Sorter().byType(books, this);
}

class _Sorter {
  List<ReadarrBook> byType(
    List<ReadarrBook> books,
    ReadarrBooksFilter type,
  ) {
    switch (type) {
      case ReadarrBooksFilter.ALL:
        return books;
      case ReadarrBooksFilter.MONITORED:
        return _monitored(books);
      case ReadarrBooksFilter.UNMONITORED:
        return _unmonitored(books);
      case ReadarrBooksFilter.MISSING:
        return _missing(books);
    }
  }

  List<ReadarrBook> _monitored(List<ReadarrBook> books) =>
      books.where((b) => b.monitored!).toList();

  List<ReadarrBook> _unmonitored(List<ReadarrBook> books) =>
      books.where((b) => !b.monitored!).toList();

  List<ReadarrBook> _missing(List<ReadarrBook> books) => books
      .where((b) =>
          (b.monitored ?? false) &&
          (b.statistics?.bookFileCount ?? 0) == 0)
      .toList();
}
