part of readarr_commands;

Future<ReadarrMissing> _commandGetMissing(
  Dio client, {
  int page = 1,
  int pageSize = 20,
  ReadarrWantedMissingSortKey sortKey = ReadarrWantedMissingSortKey.TITLE,
  ReadarrSortDir sortDirection = ReadarrSortDir.ASCENDING,
  bool includeAuthor = true,
}) async {
  Response response = await client.get('wanted/missing', queryParameters: {
    'page': page,
    'pageSize': pageSize,
    'sortKey': sortKey.value,
    'sortDirection': sortDirection.value,
    'includeAuthor': includeAuthor,
  });
  return ReadarrMissing.fromJson(response.data);
}
