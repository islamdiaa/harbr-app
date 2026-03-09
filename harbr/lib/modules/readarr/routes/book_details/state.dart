import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrBookDetailsState extends ChangeNotifier {
  ReadarrBookDetailsState({
    required BuildContext context,
    required this.bookId,
  }) {
    fetchBook(context);
    fetchHistory(context);
  }

  final int bookId;

  Future<ReadarrBook>? _book;
  Future<ReadarrBook>? get book => _book;
  void fetchBook(BuildContext context) {
    if (context.read<ReadarrState>().enabled) {
      _book = context.read<ReadarrState>().api!.book.get(bookId: bookId);
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
          .getByBook(bookId: bookId);
    }
    notifyListeners();
  }
}
