import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAuthorDetailsState extends ChangeNotifier {
  final ReadarrAuthor author;

  ReadarrAuthorDetailsState({
    required BuildContext context,
    required this.author,
  }) {
    fetchBooks(context);
    fetchHistory(context);
  }

  Future<List<ReadarrBook>>? _books;
  Future<List<ReadarrBook>>? get books => _books;
  void fetchBooks(BuildContext context) {
    if (context.read<ReadarrState>().enabled) {
      _books = context
          .read<ReadarrState>()
          .api!
          .book
          .getAll()
          .then((books) =>
              books.where((b) => b.authorId == author.id).toList());
    }
    notifyListeners();
  }

  Future<List<ReadarrHistoryRecord>>? _history;
  Future<List<ReadarrHistoryRecord>>? get history => _history;
  void fetchHistory(BuildContext context) {
    if (context.read<ReadarrState>().enabled) {
      _history = context
          .read<ReadarrState>()
          .api!
          .history
          .getByAuthor(authorId: author.id!);
    }
    notifyListeners();
  }
}
