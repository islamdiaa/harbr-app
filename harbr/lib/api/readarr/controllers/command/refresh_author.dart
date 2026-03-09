part of readarr_commands;

Future<ReadarrCommand> _commandRefreshAuthor(
  Dio client, {
  int? authorId,
}) async {
  Map<String, dynamic> data = {
    'name': 'RefreshAuthor',
  };
  if (authorId != null) data['authorId'] = authorId;
  Response response = await client.post('command', data: data);
  return ReadarrCommand.fromJson(response.data);
}
