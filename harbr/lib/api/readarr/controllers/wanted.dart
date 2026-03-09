part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to wanted/missing within Readarr.
///
/// [ReadarrControllerWanted] internally handles routing the HTTP client to the API calls.
class ReadarrControllerWanted {
  final Dio _client;

  /// Create a wanted command handler using an initialized [Dio] client.
  ReadarrControllerWanted(this._client);

  /// Handler for `wanted/missing`.
  ///
  /// Returns a paginated list of missing books.
  Future<ReadarrMissing> getMissing({
    int page = 1,
    int pageSize = 20,
    ReadarrWantedMissingSortKey sortKey = ReadarrWantedMissingSortKey.TITLE,
    ReadarrSortDir sortDirection = ReadarrSortDir.ASCENDING,
    bool includeAuthor = true,
  }) async =>
      _commandGetMissing(
        _client,
        page: page,
        pageSize: pageSize,
        sortKey: sortKey,
        sortDirection: sortDirection,
        includeAuthor: includeAuthor,
      );
}
