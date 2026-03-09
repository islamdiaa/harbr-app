part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to commands within Readarr.
///
/// [ReadarrControllerCommand] internally handles routing the HTTP client to the API calls.
class ReadarrControllerCommand {
  final Dio _client;

  /// Create a command handler using an initialized [Dio] client.
  ReadarrControllerCommand(this._client);

  /// Handler for triggering a backup.
  Future<ReadarrCommand> backup() async =>
      _commandBackup(_client);

  /// Handler for triggering an author search.
  Future<ReadarrCommand> authorSearch({
    required int authorId,
  }) async =>
      _commandAuthorSearch(_client, authorId: authorId);

  /// Handler for triggering a book search.
  Future<ReadarrCommand> bookSearch({
    required int bookId,
  }) async =>
      _commandBookSearch(_client, bookId: bookId);

  /// Handler for triggering a missing book search.
  Future<ReadarrCommand> missingBookSearch() async =>
      _commandMissingBookSearch(_client);

  /// Handler for triggering an author refresh.
  Future<ReadarrCommand> refreshAuthor({
    int? authorId,
  }) async =>
      _commandRefreshAuthor(_client, authorId: authorId);

  /// Handler for triggering a refresh of monitored downloads.
  Future<ReadarrCommand> refreshMonitoredDownloads() async =>
      _commandRefreshMonitoredDownloads(_client);

  /// Handler for triggering a rescan of folders.
  Future<ReadarrCommand> rescanFolders() async =>
      _commandRescanFolders(_client);

  /// Handler for triggering an RSS sync.
  Future<ReadarrCommand> rssSync() async =>
      _commandRssSync(_client);
}
