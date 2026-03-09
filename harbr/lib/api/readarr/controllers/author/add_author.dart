part of readarr_commands;

Future<ReadarrAuthor> _commandAddAuthor(
  Dio client, {
  required ReadarrAuthor author,
}) async {
  Response response = await client.post('author', data: author.toJson());
  return ReadarrAuthor.fromJson(response.data);
}
