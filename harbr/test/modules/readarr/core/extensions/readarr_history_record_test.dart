import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/history/history_record.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/readarr/core/extensions/readarr_history_record.dart';

void main() {
  group('ReadarrHistoryRecordExtension', () {
    group('harbrTitle', () {
      test('returns sourceTitle when present', () {
        final record =
            ReadarrHistoryRecord(sourceTitle: 'Book.Title.EPUB-GROUP');
        expect(record.harbrTitle, 'Book.Title.EPUB-GROUP');
      });

      test('returns emdash when sourceTitle is null', () {
        final record = ReadarrHistoryRecord();
        expect(record.harbrTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when sourceTitle is empty', () {
        final record = ReadarrHistoryRecord(sourceTitle: '');
        expect(record.harbrTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrEventType', () {
      test('returns title-cased event type when present', () {
        final record = ReadarrHistoryRecord(eventType: 'grabbed');
        expect(record.harbrEventType, 'Grabbed');
      });

      test('returns emdash when eventType is null', () {
        final record = ReadarrHistoryRecord();
        expect(record.harbrEventType, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when eventType is empty', () {
        final record = ReadarrHistoryRecord(eventType: '');
        expect(record.harbrEventType, HarbrUI.TEXT_EMDASH);
      });

      test('title-cases camelCase event types', () {
        final record = ReadarrHistoryRecord(eventType: 'downloadImported');
        expect(record.harbrEventType, 'DownloadImported');
      });

      test('handles single character event type', () {
        final record = ReadarrHistoryRecord(eventType: 'a');
        expect(record.harbrEventType, 'A');
      });
    });
  });
}
