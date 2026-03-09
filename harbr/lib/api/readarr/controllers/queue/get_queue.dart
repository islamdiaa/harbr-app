part of readarr_commands;

Future<ReadarrQueue> _commandGetQueue(
  Dio client, {
  int page = 1,
  int pageSize = 50,
  ReadarrQueueSortKey sortKey = ReadarrQueueSortKey.TIMELEFT,
  ReadarrSortDir sortDirection = ReadarrSortDir.ASCENDING,
  bool includeAuthor = true,
  bool includeBook = true,
}) async {
  Response response = await client.get('queue', queryParameters: {
    'page': page,
    'pageSize': pageSize,
    'sortKey': sortKey.value,
    'sortDirection': sortDirection.value,
    'includeAuthor': includeAuthor,
    'includeBook': includeBook,
  });
  return ReadarrQueue.fromJson(response.data);
}
