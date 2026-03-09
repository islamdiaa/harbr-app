import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/book/book.dart';
import 'package:harbr/modules/readarr/routes/edit_book/state.dart';
import 'package:harbr/types/loading_state.dart';

void main() {
  group('ReadarrEditBookState', () {
    late ReadarrEditBookState state;

    setUp(() {
      state = ReadarrEditBookState();
    });

    group('initial state', () {
      test('book is null by default', () {
        expect(state.book, isNull);
      });

      test('state is INACTIVE by default', () {
        expect(state.state, HarbrLoadingState.INACTIVE);
      });

      test('canExecuteAction is false by default', () {
        expect(state.canExecuteAction, false);
      });
    });

    group('book setter', () {
      test('setting book updates the value', () {
        final book = ReadarrBook(id: 1, title: 'Test Book', monitored: true);
        state.book = book;
        expect(state.book, isNotNull);
        expect(state.book!.id, 1);
        expect(state.book!.title, 'Test Book');
        expect(state.book!.monitored, true);
      });

      test('setting book notifies listeners', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.book = ReadarrBook(id: 1, title: 'Book');
        expect(notifyCount, 1);
      });

      test('setting book to null notifies listeners', () {
        state.book = ReadarrBook(id: 1);
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.book = null;
        expect(notifyCount, 1);
        expect(state.book, isNull);
      });

      test('setting book multiple times notifies each time', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.book = ReadarrBook(id: 1);
        state.book = ReadarrBook(id: 2);
        state.book = ReadarrBook(id: 3);
        expect(notifyCount, 3);
      });
    });

    group('monitored toggle via book', () {
      test('toggling monitored on the book object changes the value', () {
        final book = ReadarrBook(id: 1, title: 'Test', monitored: false);
        state.book = book;

        state.book!.monitored = true;
        expect(state.book!.monitored, true);

        state.book!.monitored = false;
        expect(state.book!.monitored, false);
      });
    });

    group('canExecuteAction', () {
      test('setting canExecuteAction to true updates and notifies', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.canExecuteAction = true;
        expect(state.canExecuteAction, true);
        expect(notifyCount, 1);
      });

      test('setting canExecuteAction to false updates and notifies', () {
        state.canExecuteAction = true;

        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.canExecuteAction = false;
        expect(state.canExecuteAction, false);
        expect(notifyCount, 1);
      });

      test('setting same value still notifies listeners', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.canExecuteAction = false;
        expect(notifyCount, 1);
      });
    });

    group('state transitions', () {
      test('INACTIVE to ACTIVE transition notifies listeners', () {
        expect(state.state, HarbrLoadingState.INACTIVE);

        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.state = HarbrLoadingState.ACTIVE;
        expect(state.state, HarbrLoadingState.ACTIVE);
        expect(notifyCount, 1);
      });

      test('ACTIVE to ERROR transition notifies listeners', () {
        state.state = HarbrLoadingState.ACTIVE;

        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.state = HarbrLoadingState.ERROR;
        expect(state.state, HarbrLoadingState.ERROR);
        expect(notifyCount, 1);
      });

      test('ERROR to INACTIVE transition notifies listeners', () {
        state.state = HarbrLoadingState.ERROR;

        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.state = HarbrLoadingState.INACTIVE;
        expect(state.state, HarbrLoadingState.INACTIVE);
        expect(notifyCount, 1);
      });

      test('full lifecycle: INACTIVE -> ACTIVE -> ERROR', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        expect(state.state, HarbrLoadingState.INACTIVE);

        state.state = HarbrLoadingState.ACTIVE;
        expect(state.state, HarbrLoadingState.ACTIVE);

        state.state = HarbrLoadingState.ERROR;
        expect(state.state, HarbrLoadingState.ERROR);

        expect(notifyCount, 2);
      });

      test('setting same state value still notifies', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.state = HarbrLoadingState.INACTIVE;
        expect(notifyCount, 1);
      });
    });

    group('initializeBook (via setter pattern)', () {
      test('setting book copies all data correctly', () {
        final book = ReadarrBook(
          id: 42,
          title: 'The Great Gatsby',
          monitored: true,
          authorId: 7,
          overview: 'A novel about the American Dream',
          pageCount: 180,
          genres: ['Fiction', 'Classic'],
        );

        state.book = book;

        expect(state.book!.id, 42);
        expect(state.book!.title, 'The Great Gatsby');
        expect(state.book!.monitored, true);
        expect(state.book!.authorId, 7);
        expect(state.book!.overview, 'A novel about the American Dream');
        expect(state.book!.pageCount, 180);
        expect(state.book!.genres, ['Fiction', 'Classic']);
      });

      test('book reference is preserved (not cloned) in state', () {
        final book = ReadarrBook(id: 1, title: 'Original');
        state.book = book;

        // Same reference
        book.title = 'Modified';
        expect(state.book!.title, 'Modified');
      });

      test('book with null fields is handled', () {
        final book = ReadarrBook();
        state.book = book;

        expect(state.book!.id, isNull);
        expect(state.book!.title, isNull);
        expect(state.book!.monitored, isNull);
        expect(state.book!.authorId, isNull);
      });
    });

    group('combined operations', () {
      test('setting book and canExecuteAction together works', () {
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.book = ReadarrBook(id: 1, title: 'Test', monitored: true);
        state.canExecuteAction = true;

        expect(state.book, isNotNull);
        expect(state.canExecuteAction, true);
        expect(notifyCount, 2);
      });

      test('state is a ChangeNotifier', () {
        expect(state, isA<ChangeNotifier>());
      });
    });

    group('dispose', () {
      test('disposed state throws when accessing after dispose', () {
        state.dispose();
        // After disposing, adding a listener should throw
        expect(() => state.addListener(() {}), throwsFlutterError);
      });
    });
  });
}
