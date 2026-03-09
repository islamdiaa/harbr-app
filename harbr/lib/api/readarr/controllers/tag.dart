part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to tags within Readarr.
///
/// [ReadarrControllerTag] internally handles routing the HTTP client to the API calls.
class ReadarrControllerTag {
  final Dio _client;

  /// Create a tag command handler using an initialized [Dio] client.
  ReadarrControllerTag(this._client);

  /// Handler for `tag`.
  ///
  /// Returns a list of all tags.
  Future<List<ReadarrTag>> getAll() async =>
      _commandGetAllTags(_client);

  /// Handler for `tag/{id}`.
  ///
  /// Returns the tag with the matching ID.
  Future<ReadarrTag> get({
    required int id,
  }) async =>
      _commandGetTag(_client, id: id);

  /// Handler for `tag` (POST).
  ///
  /// Creates a new tag.
  Future<ReadarrTag> create({
    required String label,
  }) async =>
      _commandAddTag(_client, label: label);

  /// Handler for `tag/{id}` (DELETE).
  ///
  /// Deletes the tag with the given ID.
  Future<void> delete({
    required int id,
  }) async =>
      _commandDeleteTag(_client, id: id);

  /// Handler for `tag` (PUT).
  ///
  /// Updates an existing tag.
  Future<ReadarrTag> update({
    required int id,
    required String label,
  }) async =>
      _commandUpdateTag(_client, id: id, label: label);
}
