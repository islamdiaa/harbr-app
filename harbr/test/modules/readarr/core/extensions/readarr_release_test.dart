import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/release/release.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/readarr/core/extensions/readarr_release.dart';

void main() {
  group('ReadarrReleaseExtension', () {
    group('harbrTitle', () {
      test('returns title when present', () {
        final release = ReadarrRelease(title: 'Book Release v1');
        expect(release.harbrTitle, 'Book Release v1');
      });

      test('returns emdash when title is null', () {
        final release = ReadarrRelease();
        expect(release.harbrTitle, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when title is empty', () {
        final release = ReadarrRelease(title: '');
        expect(release.harbrTitle, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrAge', () {
      test('returns emdash when age is null', () {
        final release = ReadarrRelease();
        expect(release.harbrAge, HarbrUI.TEXT_EMDASH);
      });

      test('returns <1d when age is 0', () {
        final release = ReadarrRelease(age: 0);
        expect(release.harbrAge, '<1d');
      });

      test('returns days format when age > 0', () {
        final release = ReadarrRelease(age: 5);
        expect(release.harbrAge, '5d');
      });

      test('returns 1d when age is 1', () {
        final release = ReadarrRelease(age: 1);
        expect(release.harbrAge, '1d');
      });

      test('returns large day count', () {
        final release = ReadarrRelease(age: 365);
        expect(release.harbrAge, '365d');
      });
    });

    group('harbrSize', () {
      test('returns 0.0 B when size is null', () {
        final release = ReadarrRelease();
        expect(release.harbrSize, '0.0 B');
      });

      test('returns formatted bytes for small sizes', () {
        final release = ReadarrRelease(size: 500);
        expect(release.harbrSize, '500.0 B');
      });

      test('returns formatted KB for KB range', () {
        final release = ReadarrRelease(size: 2048);
        expect(release.harbrSize, '2.0 KB');
      });

      test('returns formatted MB for MB range', () {
        final release = ReadarrRelease(size: 5242880);
        expect(release.harbrSize, '5.0 MB');
      });

      test('returns 0.0 B when size is 0', () {
        final release = ReadarrRelease(size: 0);
        expect(release.harbrSize, '0.0 B');
      });
    });

    group('harbrIndexer', () {
      test('returns indexer when present', () {
        final release = ReadarrRelease(indexer: 'NZBgeek');
        expect(release.harbrIndexer, 'NZBgeek');
      });

      test('returns emdash when indexer is null', () {
        final release = ReadarrRelease();
        expect(release.harbrIndexer, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when indexer is empty', () {
        final release = ReadarrRelease(indexer: '');
        expect(release.harbrIndexer, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrSeeders', () {
      test('returns seeders count when protocol is torrent', () {
        final release = ReadarrRelease(protocol: 'torrent', seeders: 10);
        expect(release.harbrSeeders, '10');
      });

      test('returns 0 when protocol is torrent but seeders is null', () {
        final release = ReadarrRelease(protocol: 'torrent');
        expect(release.harbrSeeders, '0');
      });

      test('returns emdash when protocol is not torrent', () {
        final release = ReadarrRelease(protocol: 'usenet', seeders: 10);
        expect(release.harbrSeeders, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when protocol is null', () {
        final release = ReadarrRelease(seeders: 10);
        expect(release.harbrSeeders, HarbrUI.TEXT_EMDASH);
      });
    });

    group('harbrLeechers', () {
      test('returns leechers count when protocol is torrent', () {
        final release = ReadarrRelease(protocol: 'torrent', leechers: 5);
        expect(release.harbrLeechers, '5');
      });

      test('returns 0 when protocol is torrent but leechers is null', () {
        final release = ReadarrRelease(protocol: 'torrent');
        expect(release.harbrLeechers, '0');
      });

      test('returns emdash when protocol is not torrent', () {
        final release = ReadarrRelease(protocol: 'usenet', leechers: 5);
        expect(release.harbrLeechers, HarbrUI.TEXT_EMDASH);
      });

      test('returns emdash when protocol is null', () {
        final release = ReadarrRelease(leechers: 5);
        expect(release.harbrLeechers, HarbrUI.TEXT_EMDASH);
      });
    });
  });
}
