part of readarr_commands;

Future<ReadarrBook> _commandAddBook(
  Dio client, {
  required ReadarrBook book,
  required int qualityProfileId,
  required int metadataProfileId,
  required String rootFolderPath,
  bool monitored = true,
  bool searchForNewBook = false,
  List<int> tags = const [],
}) async {
  // Get cached extra data from the search results
  Map<String, String>? extraData =
      getBookLookupExtraData(book.foreignBookId);
  String? foreignEditionId = extraData?['foreignEditionId'];
  String? foreignAuthorId = extraData?['foreignAuthorId'];
  String? authorName = extraData?['authorName'];

  // Fallback: if no cached author data, try author lookup
  if (foreignAuthorId == null || foreignAuthorId.isEmpty) {
    String? authorTitle = extraData?['authorTitle'];
    String? authorSearchName;
    if (authorTitle != null && authorTitle.isNotEmpty) {
      String? bookTitle = book.title;
      if (bookTitle != null &&
          authorTitle.toLowerCase().contains(bookTitle.toLowerCase())) {
        int idx = authorTitle.toLowerCase().indexOf(bookTitle.toLowerCase());
        authorSearchName = authorTitle.substring(0, idx).trim();
      } else {
        authorSearchName = authorTitle;
      }
    }
    if (authorSearchName != null && authorSearchName.isNotEmpty) {
      try {
        List<ReadarrAuthor> authors =
            await _commandAuthorLookup(client, term: authorSearchName);
        if (authors.isNotEmpty) {
          foreignAuthorId = authors.first.foreignAuthorId;
          authorName = authors.first.authorName;
        }
      } catch (_) {
        // Author lookup failed, will try without
      }
    }
  }

  // Build the payload with all required fields
  Map<String, dynamic> payload = {
    'foreignBookId': book.foreignBookId,
    'title': book.title,
    'titleSlug': book.titleSlug ?? book.foreignBookId,
    'monitored': monitored,
    'anyEditionOk': book.anyEditionOk ?? true,
    'editions': [
      {
        'foreignEditionId': foreignEditionId ?? book.foreignBookId,
        'title': book.title,
        'monitored': true,
      }
    ],
    'author': {
      'foreignAuthorId': foreignAuthorId ?? '',
      'authorName': authorName ?? '',
      'qualityProfileId': qualityProfileId,
      'metadataProfileId': metadataProfileId,
      'rootFolderPath': rootFolderPath,
      'monitored': true,
      'tags': tags,
    },
    'addOptions': {
      'addType': 'automatic',
      'searchForNewBook': searchForNewBook,
    },
  };

  Response response = await client.post('book', data: payload);
  return ReadarrBook.fromJson(response.data);
}
