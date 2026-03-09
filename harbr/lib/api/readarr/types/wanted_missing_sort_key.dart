part of readarr_types;

enum ReadarrWantedMissingSortKey {
  TITLE('title'),
  RELEASE_DATE('books.releaseDate');

  final String value;
  const ReadarrWantedMissingSortKey(this.value);

  ReadarrWantedMissingSortKey? from(String? value) {
    for (var key in ReadarrWantedMissingSortKey.values) {
      if (key.value == value) return key;
    }
    return null;
  }
}
