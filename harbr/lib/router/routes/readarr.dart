import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/core/state.dart';
import 'package:harbr/modules/readarr/routes/add_book/route.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/route.dart';
import 'package:harbr/modules/readarr/routes/author_details/route.dart';
import 'package:harbr/modules/readarr/routes/book_details/route.dart';
import 'package:harbr/modules/readarr/routes/edit_author/route.dart';
import 'package:harbr/modules/readarr/routes/edit_book/route.dart';
import 'package:harbr/modules/readarr/routes/history/route.dart';
import 'package:harbr/modules/readarr/routes/queue/route.dart';
import 'package:harbr/modules/readarr/routes/readarr/route.dart';
import 'package:harbr/modules/readarr/routes/releases/route.dart';
import 'package:harbr/modules/readarr/routes/tags/route.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

enum ReadarrRoutes with HarbrRoutesMixin {
  HOME('/readarr'),
  ADD_BOOK('add_book'),
  ADD_BOOK_DETAILS('details'),
  AUTHOR('author/:author'),
  AUTHOR_EDIT('edit'),
  BOOK('book/:book'),
  BOOK_EDIT('edit'),
  HISTORY('history'),
  QUEUE('queue'),
  RELEASES('releases'),
  TAGS('tags');

  @override
  final String path;
  const ReadarrRoutes(this.path);

  @override
  HarbrModule get module => HarbrModule.READARR;

  @override
  bool isModuleEnabled(BuildContext context) {
    return context.read<ReadarrState>().enabled;
  }

  @override
  GoRoute get routes {
    switch (this) {
      case ReadarrRoutes.HOME:
        return route(widget: const ReadarrRoute());
      case ReadarrRoutes.ADD_BOOK:
        return route(builder: (_, state) {
          final query = state.uri.queryParameters['query'] ?? '';
          return ReadarrAddBookRoute(query: query);
        });
      case ReadarrRoutes.ADD_BOOK_DETAILS:
        return route(builder: (_, state) {
          final book = state.extra as ReadarrBook?;
          return ReadarrAddBookDetailsRoute(book: book);
        });
      case ReadarrRoutes.AUTHOR:
        return route(builder: (_, state) {
          final authorId =
              int.tryParse(state.pathParameters['author'] ?? '-1') ?? -1;
          return ReadarrAuthorDetailsRoute(authorId: authorId);
        });
      case ReadarrRoutes.AUTHOR_EDIT:
        return route(builder: (_, state) {
          final authorId =
              int.tryParse(state.pathParameters['author'] ?? '-1') ?? -1;
          return ReadarrEditAuthorRoute(authorId: authorId);
        });
      case ReadarrRoutes.BOOK:
        return route(builder: (_, state) {
          final bookId =
              int.tryParse(state.pathParameters['book'] ?? '-1') ?? -1;
          return ReadarrBookDetailsRoute(bookId: bookId);
        });
      case ReadarrRoutes.BOOK_EDIT:
        return route(builder: (_, state) {
          final bookId =
              int.tryParse(state.pathParameters['book'] ?? '-1') ?? -1;
          return ReadarrEditBookRoute(bookId: bookId);
        });
      case ReadarrRoutes.HISTORY:
        return route(widget: const ReadarrHistoryRoute());
      case ReadarrRoutes.QUEUE:
        return route(widget: const ReadarrQueueRoute());
      case ReadarrRoutes.RELEASES:
        return route(builder: (_, state) {
          final bookId =
              int.tryParse(state.uri.queryParameters['book'] ?? '');
          return ReadarrReleasesRoute(bookId: bookId);
        });
      case ReadarrRoutes.TAGS:
        return route(widget: const ReadarrTagsRoute());
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case ReadarrRoutes.HOME:
        return [
          ReadarrRoutes.ADD_BOOK.routes,
          ReadarrRoutes.AUTHOR.routes,
          ReadarrRoutes.BOOK.routes,
          ReadarrRoutes.HISTORY.routes,
          ReadarrRoutes.QUEUE.routes,
          ReadarrRoutes.RELEASES.routes,
          ReadarrRoutes.TAGS.routes,
        ];
      case ReadarrRoutes.ADD_BOOK:
        return [ReadarrRoutes.ADD_BOOK_DETAILS.routes];
      case ReadarrRoutes.AUTHOR:
        return [ReadarrRoutes.AUTHOR_EDIT.routes];
      case ReadarrRoutes.BOOK:
        return [ReadarrRoutes.BOOK_EDIT.routes];
      default:
        return const [];
    }
  }
}
