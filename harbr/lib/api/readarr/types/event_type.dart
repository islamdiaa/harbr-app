part of readarr_types;

enum ReadarrEventType {
  GRABBED('grabbed'),
  BOOK_FILE_IMPORTED('bookFileImported'),
  BOOK_FILE_UPGRADED('bookFileUpgraded'),
  BOOK_FILE_RENAMED('bookFileRenamed'),
  BOOK_FILE_DELETED('bookFileDeleted'),
  BOOK_FILE_RETAGGED('bookFileRetagged'),
  DOWNLOAD_FAILED('downloadFailed'),
  DOWNLOAD_IMPORTED('downloadImported'),
  BOOK_IMPORTED('bookImported');

  final String value;
  const ReadarrEventType(this.value);

  ReadarrEventType? from(String? value) {
    for (var type in ReadarrEventType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
