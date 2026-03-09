part of readarr_commands;

Future<ReadarrCommand> _commandMissingBookSearch(Dio client) async {
  Response response = await client.post('command', data: {
    'name': 'MissingBookSearch',
  });
  return ReadarrCommand.fromJson(response.data);
}
