part of readarr_types;

enum ReadarrQueueStatus {
  DOWNLOADING('downloading'),
  PAUSED('paused'),
  QUEUED('queued'),
  COMPLETED('completed'),
  DELAY('delay'),
  DOWNLOAD_CLIENT_UNAVAILABLE('downloadClientUnavailable'),
  FAILED('failed'),
  WARNING('warning');

  final String value;
  const ReadarrQueueStatus(this.value);

  ReadarrQueueStatus? from(String? value) {
    for (var status in ReadarrQueueStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }
}
