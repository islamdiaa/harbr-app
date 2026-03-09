import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/queue/queue_record.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/readarr/core/extensions/readarr_queue_record.dart';

void main() {
  group('ReadarrQueueRecordExtension', () {
    group('harbrTitle', () {
      test('returns title when present', () {
        final record = ReadarrQueueRecord(title: 'Book Download');
        expect(record.harbrTitle, 'Book Download');
      });

      test('returns emdash when title is null', () {
        final record = ReadarrQueueRecord();
        expect(record.harbrTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when title is empty', () {
        final record = ReadarrQueueRecord(title: '');
        expect(record.harbrTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrStatus', () {
      test('returns title-cased status when present', () {
        final record = ReadarrQueueRecord(status: 'downloading');
        expect(record.harbrStatus, 'Downloading');
      });

      test('returns emdash when status is null', () {
        final record = ReadarrQueueRecord();
        expect(record.harbrStatus, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when status is empty', () {
        final record = ReadarrQueueRecord(status: '');
        expect(record.harbrStatus, HarbrUI.TEXT_EMDASH);
      });

      test('title-cases multi-word status', () {
        final record = ReadarrQueueRecord(status: 'download complete');
        expect(record.harbrStatus, 'Download Complete');
      });
    });

    group('harbrPercentDone', () {
      test('returns 0.0% when size is null', () {
        final record = ReadarrQueueRecord(sizeleft: 100);
        expect(record.harbrPercentDone, '0.0%');
      });

      test('returns 0.0% when size is 0', () {
        final record = ReadarrQueueRecord(size: 0, sizeleft: 0);
        expect(record.harbrPercentDone, '0.0%');
      });

      test('returns 100.0% when sizeleft is 0', () {
        final record = ReadarrQueueRecord(size: 1000, sizeleft: 0);
        expect(record.harbrPercentDone, '100.0%');
      });

      test('returns correct percentage for partial download', () {
        final record = ReadarrQueueRecord(size: 1000, sizeleft: 500);
        expect(record.harbrPercentDone, '50.0%');
      });

      test('returns 0.0% when sizeleft equals size', () {
        final record = ReadarrQueueRecord(size: 1000, sizeleft: 1000);
        expect(record.harbrPercentDone, '0.0%');
      });

      test('handles null sizeleft as 0', () {
        final record = ReadarrQueueRecord(size: 1000);
        expect(record.harbrPercentDone, '100.0%');
      });

      test('returns correct percentage for 75% done', () {
        final record = ReadarrQueueRecord(size: 1000, sizeleft: 250);
        expect(record.harbrPercentDone, '75.0%');
      });

      test('returns 0.0% with decimal precision', () {
        final record = ReadarrQueueRecord(size: 3, sizeleft: 2);
        expect(record.harbrPercentDone, '33.3%');
      });
    });

    group('harbrSizeleft', () {
      test('returns 0.0 B when sizeleft is null', () {
        final record = ReadarrQueueRecord();
        expect(record.harbrSizeleft, '0.0 B');
      });

      test('returns formatted bytes for small size', () {
        final record = ReadarrQueueRecord(sizeleft: 500);
        expect(record.harbrSizeleft, '500.0 B');
      });

      test('returns formatted KB', () {
        final record = ReadarrQueueRecord(sizeleft: 2048);
        expect(record.harbrSizeleft, '2.0 KB');
      });

      test('returns formatted MB', () {
        final record = ReadarrQueueRecord(sizeleft: 5242880);
        expect(record.harbrSizeleft, '5.0 MB');
      });

      test('returns 0.0 B for sizeleft of 0', () {
        final record = ReadarrQueueRecord(sizeleft: 0);
        expect(record.harbrSizeleft, '0.0 B');
      });
    });
  });
}
