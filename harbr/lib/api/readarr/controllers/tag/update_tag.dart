part of readarr_commands;

Future<ReadarrTag> _commandUpdateTag(
  Dio client, {
  required int id,
  required String label,
}) async {
  Response response = await client.put('tag', data: {
    'id': id,
    'label': label,
  });
  return ReadarrTag.fromJson(response.data);
}
