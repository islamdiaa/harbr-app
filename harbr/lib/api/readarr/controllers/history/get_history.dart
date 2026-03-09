part of readarr_commands;

Future<ReadarrHistory> _commandGetHistory(
  Dio client, {
  int page = 1,
  int pageSize = 20,
  ReadarrHistorySortKey sortKey = ReadarrHistorySortKey.DATE,
  ReadarrSortDir sortDirection = ReadarrSortDir.DESCENDING,
}) async {
  Response response = await client.get('history', queryParameters: {
    'page': page,
    'pageSize': pageSize,
    'sortKey': sortKey.value,
    'sortDirection': sortDirection.value,
  });
  return ReadarrHistory.fromJson(response.data);
}
