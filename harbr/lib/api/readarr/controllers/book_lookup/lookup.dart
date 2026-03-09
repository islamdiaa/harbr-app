part of readarr_commands;

/// Cache of extra fields from book lookup that aren't in the ReadarrBook model.
/// Keyed by foreignBookId.
final Map<String, Map<String, String>> _bookLookupExtraData = {};

/// Get cached extra data for a book by its foreignBookId.
Map<String, String>? getBookLookupExtraData(String? foreignBookId) {
  if (foreignBookId == null) return null;
  return _bookLookupExtraData[foreignBookId];
}

/// Parse author name from authorTitle field.
/// Format is "lastname, firstname BookTitle" e.g. "huyen, chip AI Engineering"
String? _parseAuthorName(String? authorTitle, String? bookTitle) {
  if (authorTitle == null || authorTitle.isEmpty) return null;
  if (bookTitle != null && bookTitle.isNotEmpty) {
    int idx = authorTitle.toLowerCase().indexOf(bookTitle.toLowerCase());
    if (idx > 0) {
      String raw = authorTitle.substring(0, idx).trim();
      // Convert "lastname, firstname" to "Firstname Lastname"
      if (raw.contains(',')) {
        List<String> parts = raw.split(',').map((p) => p.trim()).toList();
        if (parts.length == 2 && parts[1].isNotEmpty) {
          String first = parts[1][0].toUpperCase() + parts[1].substring(1);
          String last = parts[0][0].toUpperCase() + parts[0].substring(1);
          return '$first $last';
        }
      }
      return raw;
    }
  }
  return authorTitle;
}

/// Uses the /search endpoint which returns better-ranked results
/// (same endpoint the Readarr web UI uses).
/// Also caches author foreignAuthorId from paired author results
/// so we don't need a separate author lookup when adding books.
Future<List<ReadarrBook>> _commandBookLookup(
  Dio client, {
  required String term,
}) async {
  Response response = await client.get('search', queryParameters: {
    'term': term,
  });

  List<ReadarrBook> books = [];
  // Track the last seen author result to pair with the next book
  String? lastAuthorForeignId;
  String? lastAuthorName;

  for (var raw in (response.data as List)) {
    Map<String, dynamic> item = raw as Map<String, dynamic>;

    // Cache author results — each book is preceded by its author
    if (item.containsKey('author') && !item.containsKey('book')) {
      Map<String, dynamic> authorData = item['author'] as Map<String, dynamic>;
      lastAuthorForeignId = authorData['foreignAuthorId']?.toString();
      lastAuthorName = authorData['authorName']?.toString();
      continue;
    }

    if (!item.containsKey('book')) continue;
    Map<String, dynamic> json = item['book'] as Map<String, dynamic>;

    String? foreignBookId = json['foreignBookId']?.toString();
    String? authorTitle = json['authorTitle']?.toString();
    String? bookTitle = json['title']?.toString();

    // Cache extra fields not in the model, including paired author data
    if (foreignBookId != null) {
      _bookLookupExtraData[foreignBookId] = {
        if (json['foreignEditionId'] != null)
          'foreignEditionId': json['foreignEditionId'].toString(),
        if (authorTitle != null) 'authorTitle': authorTitle,
        if (lastAuthorForeignId != null)
          'foreignAuthorId': lastAuthorForeignId,
        if (lastAuthorName != null) 'authorName': lastAuthorName,
      };
    }

    ReadarrBook book = ReadarrBook.fromJson(json);

    // Set author with the name from the paired author result or parsed from authorTitle
    if (book.author == null) {
      String? authorName =
          lastAuthorName ?? _parseAuthorName(authorTitle, bookTitle);
      if (authorName != null && authorName.isNotEmpty) {
        book.author = ReadarrAuthor(authorName: authorName);
      }
    }

    books.add(book);
  }
  return books;
}
