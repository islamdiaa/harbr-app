import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAddBookState extends ChangeNotifier {
  ReadarrAddBookState(BuildContext context, String query) {
    _searchQuery = query;
    if (query.isNotEmpty) {
      fetchLookup(context);
    }
  }

  late String _searchQuery;
  String get searchQuery => _searchQuery;
  set searchQuery(String searchQuery) {
    _searchQuery = searchQuery;
    notifyListeners();
  }

  Future<List<ReadarrBook>>? _lookup;
  Future<List<ReadarrBook>>? get lookup => _lookup;
  void fetchLookup(BuildContext context) {
    if (context.read<ReadarrState>().enabled) {
      _lookup = context
          .read<ReadarrState>()
          .api!
          .bookLookup
          .lookup(term: _searchQuery)
          .catchError((error, stack) {
        HarbrLogger().error('Book lookup failed', error, stack);
        throw error;
      });
    }
    notifyListeners();
  }
}
