part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to authors within Readarr.
///
/// [ReadarrControllerAuthor] internally handles routing the HTTP client to the API calls.
class ReadarrControllerAuthor {
  final Dio _client;

  /// Create an author command handler using an initialized [Dio] client.
  ReadarrControllerAuthor(this._client);

  /// Handler for `author`.
  ///
  /// Returns a list of all authors.
  Future<List<ReadarrAuthor>> getAll() async =>
      _commandGetAllAuthors(_client);

  /// Handler for `author/{id}`.
  ///
  /// Returns the author with the matching ID.
  Future<ReadarrAuthor> get({
    required int authorId,
  }) async =>
      _commandGetAuthor(_client, authorId: authorId);

  /// Handler for `author/lookup`.
  ///
  /// Search for authors by name.
  Future<List<ReadarrAuthor>> lookup({
    required String term,
  }) async =>
      _commandAuthorLookup(_client, term: term);

  /// Handler for `author` (POST).
  ///
  /// Adds a new author to your collection.
  Future<ReadarrAuthor> create({
    required ReadarrAuthor author,
  }) async =>
      _commandAddAuthor(_client, author: author);

  /// Handler for `author` (PUT).
  ///
  /// Update an existing author.
  Future<ReadarrAuthor> update({
    required ReadarrAuthor author,
  }) async =>
      _commandUpdateAuthor(_client, author: author);

  /// Handler for `author/{id}` (DELETE).
  ///
  /// Delete the author with the given ID.
  Future<void> delete({
    required int authorId,
    bool deleteFiles = false,
    bool addImportListExclusion = false,
  }) async =>
      _commandDeleteAuthor(
        _client,
        authorId: authorId,
        deleteFiles: deleteFiles,
        addImportListExclusion: addImportListExclusion,
      );
}
