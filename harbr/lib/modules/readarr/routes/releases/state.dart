import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrReleasesState extends ChangeNotifier {
  final int? bookId;

  ReadarrReleasesState({
    required BuildContext context,
    this.bookId,
  }) {
    refreshReleases(context);
  }

  Future<List<ReadarrRelease>>? _releases;
  Future<List<ReadarrRelease>>? get releases => _releases;
  void refreshReleases(BuildContext context) {
    if (context.read<ReadarrState>().enabled && bookId != null) {
      _releases =
          context.read<ReadarrState>().api!.release.get(bookId: bookId!);
    }
    notifyListeners();
  }

  bool _hideRejected = true;
  bool get hideRejected => _hideRejected;
  set hideRejected(bool value) {
    _hideRejected = value;
    notifyListeners();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String searchQuery) {
    _searchQuery = searchQuery;
    notifyListeners();
  }

  ReadarrReleasesFilter _filterType = ReadarrReleasesFilter.ALL;
  ReadarrReleasesFilter get filterType => _filterType;
  set filterType(ReadarrReleasesFilter filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  ReadarrReleasesSorting _sortType = ReadarrReleasesSorting.WEIGHT;
  ReadarrReleasesSorting get sortType => _sortType;
  set sortType(ReadarrReleasesSorting sortType) {
    _sortType = sortType;
    notifyListeners();
  }

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;
  set sortAscending(bool sortAscending) {
    _sortAscending = sortAscending;
    notifyListeners();
  }
}
