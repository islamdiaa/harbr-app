part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to book lookups within Readarr.
///
/// [ReadarrControllerBookLookup] internally handles routing the HTTP client to the API calls.
class ReadarrControllerBookLookup {
  final Dio _client;

  /// Create a book lookup command handler using an initialized [Dio] client.
  ReadarrControllerBookLookup(this._client);

  /// Handler for `book/lookup`.
  ///
  /// Search for new books using a term.
  Future<List<ReadarrBook>> lookup({
    required String term,
  }) async =>
      _commandBookLookup(_client, term: term);
}
