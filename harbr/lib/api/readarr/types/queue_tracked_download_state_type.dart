part of readarr_types;

enum ReadarrTrackedDownloadState {
  DOWNLOADING('downloading'),
  IMPORT_PENDING('importPending'),
  IMPORTING('importing'),
  IMPORTED('imported'),
  FAILED_PENDING('failedPending'),
  FAILED('failed'),
  IGNORED('ignored');

  final String value;
  const ReadarrTrackedDownloadState(this.value);

  ReadarrTrackedDownloadState? from(String? value) {
    for (var state in ReadarrTrackedDownloadState.values) {
      if (state.value == value) return state;
    }
    return null;
  }
}
