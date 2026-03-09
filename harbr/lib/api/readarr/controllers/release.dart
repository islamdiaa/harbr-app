part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to releases within Readarr.
///
/// [ReadarrControllerRelease] internally handles routing the HTTP client to the API calls.
class ReadarrControllerRelease {
  final Dio _client;

  /// Create a release command handler using an initialized [Dio] client.
  ReadarrControllerRelease(this._client);

  /// Handler for `release`.
  ///
  /// Returns a list of releases for the given book.
  Future<List<ReadarrRelease>> get({
    required int bookId,
  }) async =>
      _commandGetRelease(_client, bookId: bookId);

  /// Handler for `release` (POST).
  ///
  /// Adds a release to the download client.
  Future<ReadarrAddedRelease> add({
    required String guid,
    required int indexerId,
  }) async =>
      _commandAddRelease(_client, guid: guid, indexerId: indexerId);
}
