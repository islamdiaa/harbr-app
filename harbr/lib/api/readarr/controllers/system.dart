part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to system within Readarr.
///
/// [ReadarrControllerSystem] internally handles routing the HTTP client to the API calls.
class ReadarrControllerSystem {
  final Dio _client;

  /// Create a system command handler using an initialized [Dio] client.
  ReadarrControllerSystem(this._client);

  /// Handler for `system/status`.
  ///
  /// Returns the system status.
  Future<ReadarrStatus> getStatus() async =>
      _commandGetStatus(_client);
}
