part of readarr_types;

enum ReadarrHistorySortKey {
  DATE('date'),
  TITLE('title');

  final String value;
  const ReadarrHistorySortKey(this.value);

  ReadarrHistorySortKey? from(String? value) {
    for (var key in ReadarrHistorySortKey.values) {
      if (key.value == value) return key;
    }
    return null;
  }
}
