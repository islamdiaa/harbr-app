part of readarr_commands;

Future<ReadarrCommand> _commandBookSearch(
  Dio client, {
  required int bookId,
}) async {
  Response response = await client.post('command', data: {
    'name': 'BookSearch',
    'bookId': bookId,
  });
  return ReadarrCommand.fromJson(response.data);
}
