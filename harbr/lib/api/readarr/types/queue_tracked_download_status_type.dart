part of readarr_types;

enum ReadarrTrackedDownloadStatus {
  OK('ok'),
  WARNING('warning'),
  ERROR('error');

  final String value;
  const ReadarrTrackedDownloadStatus(this.value);

  ReadarrTrackedDownloadStatus? from(String? value) {
    for (var status in ReadarrTrackedDownloadStatus.values) {
      if (status.value == value) return status;
    }
    return null;
  }
}
