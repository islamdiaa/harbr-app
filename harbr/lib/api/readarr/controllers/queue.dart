part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to the queue within Readarr.
///
/// [ReadarrControllerQueue] internally handles routing the HTTP client to the API calls.
class ReadarrControllerQueue {
  final Dio _client;

  /// Create a queue command handler using an initialized [Dio] client.
  ReadarrControllerQueue(this._client);

  /// Handler for `queue`.
  ///
  /// Returns a paginated list of queue records.
  Future<ReadarrQueue> get({
    int page = 1,
    int pageSize = 50,
    ReadarrQueueSortKey sortKey = ReadarrQueueSortKey.TIMELEFT,
    ReadarrSortDir sortDirection = ReadarrSortDir.ASCENDING,
    bool includeAuthor = true,
    bool includeBook = true,
  }) async =>
      _commandGetQueue(
        _client,
        page: page,
        pageSize: pageSize,
        sortKey: sortKey,
        sortDirection: sortDirection,
        includeAuthor: includeAuthor,
        includeBook: includeBook,
      );

  /// Handler for `queue/{id}` (DELETE).
  ///
  /// Remove an item from the queue.
  Future<void> delete({
    required int id,
    bool removeFromClient = true,
    bool blocklist = false,
  }) async =>
      _commandDeleteQueue(
        _client,
        id: id,
        removeFromClient: removeFromClient,
        blocklist: blocklist,
      );
}
