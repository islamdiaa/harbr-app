part of readarr_types;

enum ReadarrSortDir {
  ASCENDING('ascending'),
  DESCENDING('descending');

  final String value;
  const ReadarrSortDir(this.value);
}
