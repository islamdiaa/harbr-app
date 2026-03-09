part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to quality profiles within Readarr.
///
/// [ReadarrControllerProfile] internally handles routing the HTTP client to the API calls.
class ReadarrControllerProfile {
  final Dio _client;

  /// Create a profile command handler using an initialized [Dio] client.
  ReadarrControllerProfile(this._client);

  /// Handler for `qualityprofile`.
  ///
  /// Returns a list of all quality profiles.
  Future<List<ReadarrQualityProfile>> getQualityProfiles() async =>
      _commandGetQualityProfiles(_client);
}
