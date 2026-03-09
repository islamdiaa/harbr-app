import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/modules/readarr/core/types/filter_books.dart';

void main() {
  group('ReadarrBooksFilter', () {
    group('key', () {
      test('ALL has key "all"', () {
        expect(ReadarrBooksFilter.ALL.key, 'all');
      });

      test('MONITORED has key "monitored"', () {
        expect(ReadarrBooksFilter.MONITORED.key, 'monitored');
      });

      test('UNMONITORED has key "unmonitored"', () {
        expect(ReadarrBooksFilter.UNMONITORED.key, 'unmonitored');
      });
    });

    group('fromKey', () {
      test('returns ALL from "all"', () {
        expect(
          ReadarrBooksFilter.ALL.fromKey('all'),
          ReadarrBooksFilter.ALL,
        );
      });

      test('returns MONITORED from "monitored"', () {
        expect(
          ReadarrBooksFilter.ALL.fromKey('monitored'),
          ReadarrBooksFilter.MONITORED,
        );
      });

      test('returns UNMONITORED from "unmonitored"', () {
        expect(
          ReadarrBooksFilter.ALL.fromKey('unmonitored'),
          ReadarrBooksFilter.UNMONITORED,
        );
      });

      test('returns null for unknown key', () {
        expect(ReadarrBooksFilter.ALL.fromKey('invalid'), isNull);
      });

      test('returns null for null key', () {
        expect(ReadarrBooksFilter.ALL.fromKey(null), isNull);
      });

      test('returns null for empty key', () {
        expect(ReadarrBooksFilter.ALL.fromKey(''), isNull);
      });
    });

    group('filter', () {
      late List<ReadarrBook> books;

      setUp(() {
        books = [
          ReadarrBook(id: 1, title: 'Book A', monitored: true),
          ReadarrBook(id: 2, title: 'Book B', monitored: false),
          ReadarrBook(id: 3, title: 'Book C', monitored: true),
          ReadarrBook(id: 4, title: 'Book D', monitored: false),
          ReadarrBook(id: 5, title: 'Book E', monitored: true),
        ];
      });

      test('ALL returns all books', () {
        final result = ReadarrBooksFilter.ALL.filter(books);
        expect(result.length, 5);
      });

      test('MONITORED returns only monitored books', () {
        final result = ReadarrBooksFilter.MONITORED.filter(books);
        expect(result.length, 3);
        expect(result.every((b) => b.monitored == true), true);
      });

      test('UNMONITORED returns only unmonitored books', () {
        final result = ReadarrBooksFilter.UNMONITORED.filter(books);
        expect(result.length, 2);
        expect(result.every((b) => b.monitored == false), true);
      });

      test('ALL returns empty list for empty input', () {
        final result = ReadarrBooksFilter.ALL.filter([]);
        expect(result, isEmpty);
      });

      test('MONITORED returns empty list when no monitored books', () {
        final unmonitoredOnly = [
          ReadarrBook(id: 1, monitored: false),
          ReadarrBook(id: 2, monitored: false),
        ];
        final result = ReadarrBooksFilter.MONITORED.filter(unmonitoredOnly);
        expect(result, isEmpty);
      });

      test('UNMONITORED returns empty list when all monitored', () {
        final monitoredOnly = [
          ReadarrBook(id: 1, monitored: true),
          ReadarrBook(id: 2, monitored: true),
        ];
        final result = ReadarrBooksFilter.UNMONITORED.filter(monitoredOnly);
        expect(result, isEmpty);
      });
    });
  });
}
