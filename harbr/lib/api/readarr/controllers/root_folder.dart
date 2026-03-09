part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to root folders within Readarr.
///
/// [ReadarrControllerRootFolder] internally handles routing the HTTP client to the API calls.
class ReadarrControllerRootFolder {
  final Dio _client;

  /// Create a root folder command handler using an initialized [Dio] client.
  ReadarrControllerRootFolder(this._client);

  /// Handler for `rootfolder`.
  ///
  /// Returns a list of all root folders.
  Future<List<ReadarrRootFolder>> getAll() async =>
      _commandGetRootFolders(_client);
}
