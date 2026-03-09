import 'package:harbr/core.dart';
import 'package:harbr/system/webhooks.dart';

class ReadarrWebhooks extends HarbrWebhooks {
  @override
  Future<void> handle(Map<dynamic, dynamic> data) async {
    _EventType? event = _EventType.GRAB.fromKey(data['event']);
    if (event == null)
      HarbrLogger().warning(
        'Unknown event type: ${data['event'] ?? 'null'}',
      );
    event?.execute(data);
  }
}

enum _EventType {
  AUTHOR_DELETE,
  BOOK_FILE_DELETE,
  DOWNLOAD,
  GRAB,
  HEALTH,
  RENAME,
  TEST,
}

extension _EventTypeExtension on _EventType {
  _EventType? fromKey(String? key) {
    switch (key) {
      case 'AuthorDelete':
        return _EventType.AUTHOR_DELETE;
      case 'BookFileDelete':
        return _EventType.BOOK_FILE_DELETE;
      case 'Download':
        return _EventType.DOWNLOAD;
      case 'Grab':
        return _EventType.GRAB;
      case 'Health':
        return _EventType.HEALTH;
      case 'Rename':
        return _EventType.RENAME;
      case 'Test':
        return _EventType.TEST;
    }
    return null;
  }

  Future<void> execute(Map<dynamic, dynamic> data) async {
    switch (this) {
      case _EventType.AUTHOR_DELETE:
        return _authorDeleteEvent(data);
      case _EventType.BOOK_FILE_DELETE:
        return _bookFileDeleteEvent(data);
      case _EventType.DOWNLOAD:
        return _downloadEvent(data);
      case _EventType.GRAB:
        return _grabEvent(data);
      case _EventType.HEALTH:
        return _healthEvent(data);
      case _EventType.RENAME:
        return _renameEvent(data);
      case _EventType.TEST:
        return _testEvent(data);
    }
  }

  Future<void> _authorDeleteEvent(Map<dynamic, dynamic> data) async =>
      HarbrModule.READARR.launch();
  Future<void> _bookFileDeleteEvent(Map<dynamic, dynamic> data) async =>
      _goToAuthorDetails(int.tryParse(data['authorId']));
  Future<void> _downloadEvent(Map<dynamic, dynamic> data) async =>
      _goToAuthorDetails(int.tryParse(data['authorId']));
  Future<void> _healthEvent(Map<dynamic, dynamic> data) async =>
      HarbrModule.READARR.launch();
  Future<void> _renameEvent(Map<dynamic, dynamic> data) async =>
      _goToAuthorDetails(int.tryParse(data['authorId']));
  Future<void> _testEvent(Map<dynamic, dynamic> data) async =>
      HarbrModule.READARR.launch();

  Future<void> _grabEvent(Map<dynamic, dynamic> data) async {
    HarbrModule.READARR.launch();
  }

  Future<void> _goToAuthorDetails(int? authorId) async {
    if (authorId != null) {
      // TODO: Navigate to author details when routes are available
      return HarbrModule.READARR.launch();
    }
    return HarbrModule.READARR.launch();
  }
}
