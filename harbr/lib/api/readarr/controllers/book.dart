part of readarr_commands;

/// Facilitates, encapsulates, and manages individual calls related to books within Readarr.
///
/// [ReadarrControllerBook] internally handles routing the HTTP client to the API calls.
class ReadarrControllerBook {
  final Dio _client;

  /// Create a book command handler using an initialized [Dio] client.
  ReadarrControllerBook(this._client);

  /// Handler for `book`.
  ///
  /// Returns a list of all books.
  Future<List<ReadarrBook>> getAll() async =>
      _commandGetAllBooks(_client);

  /// Handler for `book/{id}`.
  ///
  /// Returns the book with the matching ID.
  Future<ReadarrBook> get({
    required int bookId,
  }) async =>
      _commandGetBook(_client, bookId: bookId);

  /// Handler for `book` (POST).
  ///
  /// Adds a new book to your collection.
  /// Automatically looks up the author and constructs the proper payload.
  Future<ReadarrBook> create({
    required ReadarrBook book,
    required int qualityProfileId,
    required int metadataProfileId,
    required String rootFolderPath,
    bool monitored = true,
    bool searchForNewBook = false,
    List<int> tags = const [],
  }) async =>
      _commandAddBook(
        _client,
        book: book,
        qualityProfileId: qualityProfileId,
        metadataProfileId: metadataProfileId,
        rootFolderPath: rootFolderPath,
        monitored: monitored,
        searchForNewBook: searchForNewBook,
        tags: tags,
      );

  /// Handler for `book` (PUT).
  ///
  /// Update an existing book.
  Future<ReadarrBook> update({
    required ReadarrBook book,
  }) async =>
      _commandUpdateBook(_client, book: book);

  /// Handler for `book/{id}` (DELETE).
  ///
  /// Delete the book with the given ID.
  Future<void> delete({
    required int bookId,
    bool deleteFiles = false,
    bool addImportListExclusion = false,
  }) async =>
      _commandDeleteBook(
        _client,
        bookId: bookId,
        deleteFiles: deleteFiles,
        addImportListExclusion: addImportListExclusion,
      );
}
