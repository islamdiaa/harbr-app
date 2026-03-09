part of readarr_commands;

Future<void> _commandDeleteQueue(
  Dio client, {
  required int id,
  bool removeFromClient = true,
  bool blocklist = false,
}) async {
  await client.delete('queue/$id', queryParameters: {
    'removeFromClient': removeFromClient,
    'blocklist': blocklist,
  });
}
