part of readarr_commands;

Future<List<ReadarrHistoryRecord>> _commandGetHistoryByBook(
  Dio client, {
  required int bookId,
}) async {
  Response response = await client.get('history/book', queryParameters: {
    'bookId': bookId,
  });
  return (response.data as List)
      .map((record) => ReadarrHistoryRecord.fromJson(record))
      .toList();
}
