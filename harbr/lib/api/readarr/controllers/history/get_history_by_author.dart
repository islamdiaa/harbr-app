part of readarr_commands;

Future<List<ReadarrHistoryRecord>> _commandGetHistoryByAuthor(
  Dio client, {
  required int authorId,
}) async {
  Response response = await client.get('history/author', queryParameters: {
    'authorId': authorId,
  });
  return (response.data as List)
      .map((record) => ReadarrHistoryRecord.fromJson(record))
      .toList();
}
