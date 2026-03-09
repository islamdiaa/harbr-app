import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrQueueState extends ChangeNotifier {
  ReadarrQueueState(BuildContext context) {
    fetchQueue(context);
  }

  Timer? _timer;
  void cancelTimer() => _timer?.cancel();
  void createTimer(BuildContext context) {
    _timer = Timer.periodic(
      Duration(seconds: ReadarrDatabase.QUEUE_REFRESH_RATE.read()),
      (_) => fetchQueue(context),
    );
  }

  late Future<ReadarrQueue> _queue;
  Future<ReadarrQueue> get queue => _queue;

  Future<void> fetchQueue(
    BuildContext context, {
    bool hardCheck = false,
  }) async {
    cancelTimer();
    if (context.read<ReadarrState>().enabled) {
      _queue = context.read<ReadarrState>().api!.queue.get(
            pageSize: ReadarrDatabase.QUEUE_PAGE_SIZE.read(),
          );
      createTimer(context);
    }
    notifyListeners();
  }
}
