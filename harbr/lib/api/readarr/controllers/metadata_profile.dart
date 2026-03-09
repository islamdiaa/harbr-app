part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to metadata profiles within Readarr.
///
/// [ReadarrControllerMetadataProfile] internally handles routing the HTTP client to the API calls.
class ReadarrControllerMetadataProfile {
  final Dio _client;

  /// Create a metadata profile command handler using an initialized [Dio] client.
  ReadarrControllerMetadataProfile(this._client);

  /// Handler for `metadataprofile`.
  ///
  /// Returns a list of all metadata profiles.
  Future<List<ReadarrMetadataProfile>> getAll() async =>
      _commandGetMetadataProfiles(_client);
}
