part of readarr_types;

enum ReadarrQueueSortKey {
  TIMELEFT('timeleft'),
  TITLE('title'),
  SIZE('size'),
  STATUS('status');

  final String value;
  const ReadarrQueueSortKey(this.value);
}
