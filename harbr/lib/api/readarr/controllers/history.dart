part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to history within Readarr.
///
/// [ReadarrControllerHistory] internally handles routing the HTTP client to the API calls.
class ReadarrControllerHistory {
  final Dio _client;

  /// Create a history command handler using an initialized [Dio] client.
  ReadarrControllerHistory(this._client);

  /// Handler for `history`.
  ///
  /// Returns a paginated list of history records.
  Future<ReadarrHistory> get({
    int page = 1,
    int pageSize = 20,
    ReadarrHistorySortKey sortKey = ReadarrHistorySortKey.DATE,
    ReadarrSortDir sortDirection = ReadarrSortDir.DESCENDING,
  }) async =>
      _commandGetHistory(
        _client,
        page: page,
        pageSize: pageSize,
        sortKey: sortKey,
        sortDirection: sortDirection,
      );

  /// Handler for `history/author`.
  ///
  /// Returns history records for a specific author.
  Future<List<ReadarrHistoryRecord>> getByAuthor({
    required int authorId,
  }) async =>
      _commandGetHistoryByAuthor(_client, authorId: authorId);

  /// Handler for `history/book`.
  ///
  /// Returns history records for a specific book.
  Future<List<ReadarrHistoryRecord>> getByBook({
    required int bookId,
  }) async =>
      _commandGetHistoryByBook(_client, bookId: bookId);
}
