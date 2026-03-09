import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/release/release.dart';
import 'package:harbr/modules/readarr/core/types/sorting_releases.dart';

void main() {
  group('ReadarrReleasesSorting', () {
    group('enum values', () {
      test('has exactly 6 values', () {
        expect(ReadarrReleasesSorting.values.length, 6);
      });

      test('contains all expected values', () {
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.AGE));
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.ALPHABETICAL));
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.SEEDERS));
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.SIZE));
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.TYPE));
        expect(ReadarrReleasesSorting.values,
            contains(ReadarrReleasesSorting.WEIGHT));
      });
    });

    group('key', () {
      test('AGE has key "age"', () {
        expect(ReadarrReleasesSorting.AGE.key, 'age');
      });

      test('ALPHABETICAL has key "abc"', () {
        expect(ReadarrReleasesSorting.ALPHABETICAL.key, 'abc');
      });

      test('SEEDERS has key "seeders"', () {
        expect(ReadarrReleasesSorting.SEEDERS.key, 'seeders');
      });

      test('SIZE has key "size"', () {
        expect(ReadarrReleasesSorting.SIZE.key, 'size');
      });

      test('TYPE has key "type"', () {
        expect(ReadarrReleasesSorting.TYPE.key, 'type');
      });

      test('WEIGHT has key "weight"', () {
        expect(ReadarrReleasesSorting.WEIGHT.key, 'weight');
      });

      test('all keys are unique', () {
        final keys =
            ReadarrReleasesSorting.values.map((s) => s.key).toSet();
        expect(keys.length, ReadarrReleasesSorting.values.length);
      });
    });

    group('readable', () {
      test('all readable values are non-empty strings', () {
        for (final sort in ReadarrReleasesSorting.values) {
          expect(sort.readable, isNotEmpty,
              reason: '${sort.name} should have a non-empty readable');
        }
      });

      test('all readable values are Strings', () {
        for (final sort in ReadarrReleasesSorting.values) {
          expect(sort.readable, isA<String>());
        }
      });
    });

    group('fromKey', () {
      test('maps "age" to AGE', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('age'),
            ReadarrReleasesSorting.AGE);
      });

      test('maps "abc" to ALPHABETICAL', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('abc'),
            ReadarrReleasesSorting.ALPHABETICAL);
      });

      test('maps "seeders" to SEEDERS', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('seeders'),
            ReadarrReleasesSorting.SEEDERS);
      });

      test('maps "size" to SIZE', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('size'),
            ReadarrReleasesSorting.SIZE);
      });

      test('maps "type" to TYPE', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('type'),
            ReadarrReleasesSorting.TYPE);
      });

      test('maps "weight" to WEIGHT', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('weight'),
            ReadarrReleasesSorting.WEIGHT);
      });

      test('returns null for unknown key', () {
        expect(ReadarrReleasesSorting.AGE.fromKey('unknown'), isNull);
      });

      test('returns null for null key', () {
        expect(ReadarrReleasesSorting.AGE.fromKey(null), isNull);
      });

      test('returns null for empty key', () {
        expect(ReadarrReleasesSorting.AGE.fromKey(''), isNull);
      });

      test('round-trips: fromKey(key) returns same sort type', () {
        for (final sort in ReadarrReleasesSorting.values) {
          expect(sort.fromKey(sort.key), sort);
        }
      });
    });

    group('sort - AGE', () {
      test('sorts ascending by ageHours', () {
        final releases = [
          ReadarrRelease(title: 'C', ageHours: 72.0),
          ReadarrRelease(title: 'A', ageHours: 1.0),
          ReadarrRelease(title: 'B', ageHours: 24.0),
        ];
        final result = ReadarrReleasesSorting.AGE.sort(releases, true);
        expect(result[0].ageHours, 1.0);
        expect(result[1].ageHours, 24.0);
        expect(result[2].ageHours, 72.0);
      });

      test('sorts descending by ageHours', () {
        final releases = [
          ReadarrRelease(title: 'A', ageHours: 1.0),
          ReadarrRelease(title: 'C', ageHours: 72.0),
          ReadarrRelease(title: 'B', ageHours: 24.0),
        ];
        final result = ReadarrReleasesSorting.AGE.sort(releases, false);
        expect(result[0].ageHours, 72.0);
        expect(result[1].ageHours, 24.0);
        expect(result[2].ageHours, 1.0);
      });

      test('handles null ageHours (treated as 0)', () {
        final releases = [
          ReadarrRelease(title: 'B', ageHours: 10.0),
          ReadarrRelease(title: 'A', ageHours: null),
          ReadarrRelease(title: 'C', ageHours: 20.0),
        ];
        final result = ReadarrReleasesSorting.AGE.sort(releases, true);
        expect(result[0].title, 'A'); // null treated as 0
        expect(result[1].title, 'B');
        expect(result[2].title, 'C');
      });
    });

    group('sort - ALPHABETICAL', () {
      test('sorts ascending by title', () {
        final releases = [
          ReadarrRelease(title: 'Zebra Release'),
          ReadarrRelease(title: 'Alpha Release'),
          ReadarrRelease(title: 'Middle Release'),
        ];
        final result =
            ReadarrReleasesSorting.ALPHABETICAL.sort(releases, true);
        expect(result[0].title, 'Alpha Release');
        expect(result[1].title, 'Middle Release');
        expect(result[2].title, 'Zebra Release');
      });

      test('sorts descending by title', () {
        final releases = [
          ReadarrRelease(title: 'Alpha Release'),
          ReadarrRelease(title: 'Zebra Release'),
          ReadarrRelease(title: 'Middle Release'),
        ];
        final result =
            ReadarrReleasesSorting.ALPHABETICAL.sort(releases, false);
        expect(result[0].title, 'Zebra Release');
        expect(result[1].title, 'Middle Release');
        expect(result[2].title, 'Alpha Release');
      });

      test('is case insensitive', () {
        final releases = [
          ReadarrRelease(title: 'zebra'),
          ReadarrRelease(title: 'Alpha'),
          ReadarrRelease(title: 'beta'),
        ];
        final result =
            ReadarrReleasesSorting.ALPHABETICAL.sort(releases, true);
        expect(result[0].title, 'Alpha');
        expect(result[1].title, 'beta');
        expect(result[2].title, 'zebra');
      });
    });

    group('sort - SEEDERS', () {
      test('sorts torrent releases by seeders ascending, usenet at end', () {
        final releases = [
          ReadarrRelease(
              title: 'Torrent C', protocol: 'torrent', seeders: 100),
          ReadarrRelease(
              title: 'Usenet A', protocol: 'usenet', releaseWeight: 1),
          ReadarrRelease(
              title: 'Torrent A', protocol: 'torrent', seeders: 10),
          ReadarrRelease(
              title: 'Torrent B', protocol: 'torrent', seeders: 50),
        ];
        final result = ReadarrReleasesSorting.SEEDERS.sort(releases, true);

        // Torrent releases should come first, sorted by seeders ascending
        expect(result[0].title, 'Torrent A');
        expect(result[1].title, 'Torrent B');
        expect(result[2].title, 'Torrent C');
        // Usenet at the end
        expect(result[3].protocol, 'usenet');
      });

      test('sorts torrent releases by seeders descending, usenet at end', () {
        final releases = [
          ReadarrRelease(
              title: 'Torrent A', protocol: 'torrent', seeders: 10),
          ReadarrRelease(
              title: 'Usenet A', protocol: 'usenet', releaseWeight: 1),
          ReadarrRelease(
              title: 'Torrent B', protocol: 'torrent', seeders: 100),
        ];
        final result = ReadarrReleasesSorting.SEEDERS.sort(releases, false);

        // Torrent first sorted by seeders descending
        expect(result[0].seeders, 100);
        expect(result[1].seeders, 10);
        // Usenet at the end
        expect(result[2].protocol, 'usenet');
      });

      test('handles null seeders in torrent (treated as -1)', () {
        final releases = [
          ReadarrRelease(
              title: 'Torrent B', protocol: 'torrent', seeders: 50),
          ReadarrRelease(
              title: 'Torrent A', protocol: 'torrent', seeders: null),
        ];
        final result = ReadarrReleasesSorting.SEEDERS.sort(releases, true);

        // null seeders treated as -1, so sorted first ascending
        expect(result[0].seeders, isNull);
        expect(result[1].seeders, 50);
      });

      test('only usenet releases returns them all', () {
        final releases = [
          ReadarrRelease(
              title: 'Usenet A', protocol: 'usenet', releaseWeight: 2),
          ReadarrRelease(
              title: 'Usenet B', protocol: 'usenet', releaseWeight: 1),
        ];
        final result = ReadarrReleasesSorting.SEEDERS.sort(releases, true);
        expect(result.length, 2);
        // All usenet, sorted by weight
        expect(result.every((r) => r.protocol == 'usenet'), true);
      });
    });

    group('sort - SIZE', () {
      test('sorts ascending by size', () {
        final releases = [
          ReadarrRelease(title: 'Large', size: 3000000),
          ReadarrRelease(title: 'Small', size: 1000000),
          ReadarrRelease(title: 'Medium', size: 2000000),
        ];
        final result = ReadarrReleasesSorting.SIZE.sort(releases, true);
        expect(result[0].size, 1000000);
        expect(result[1].size, 2000000);
        expect(result[2].size, 3000000);
      });

      test('sorts descending by size', () {
        final releases = [
          ReadarrRelease(title: 'Small', size: 1000000),
          ReadarrRelease(title: 'Large', size: 3000000),
          ReadarrRelease(title: 'Medium', size: 2000000),
        ];
        final result = ReadarrReleasesSorting.SIZE.sort(releases, false);
        expect(result[0].size, 3000000);
        expect(result[1].size, 2000000);
        expect(result[2].size, 1000000);
      });

      test('handles null size (treated as -1)', () {
        final releases = [
          ReadarrRelease(title: 'Has Size', size: 500),
          ReadarrRelease(title: 'No Size', size: null),
        ];
        final result = ReadarrReleasesSorting.SIZE.sort(releases, true);
        expect(result[0].size, isNull); // -1 sorts first
        expect(result[1].size, 500);
      });
    });

    group('sort - TYPE', () {
      test('ascending puts torrent first, usenet second', () {
        final releases = [
          ReadarrRelease(
              title: 'Usenet 1',
              protocol: 'usenet',
              releaseWeight: 1),
          ReadarrRelease(
              title: 'Torrent 1',
              protocol: 'torrent',
              releaseWeight: 1),
          ReadarrRelease(
              title: 'Usenet 2',
              protocol: 'usenet',
              releaseWeight: 2),
          ReadarrRelease(
              title: 'Torrent 2',
              protocol: 'torrent',
              releaseWeight: 2),
        ];
        final result = ReadarrReleasesSorting.TYPE.sort(releases, true);

        // Ascending: torrent first, usenet second
        expect(result[0].protocol, 'torrent');
        expect(result[1].protocol, 'torrent');
        expect(result[2].protocol, 'usenet');
        expect(result[3].protocol, 'usenet');
      });

      test('descending puts usenet first, torrent second', () {
        final releases = [
          ReadarrRelease(
              title: 'Torrent 1',
              protocol: 'torrent',
              releaseWeight: 1),
          ReadarrRelease(
              title: 'Usenet 1',
              protocol: 'usenet',
              releaseWeight: 1),
        ];
        final result = ReadarrReleasesSorting.TYPE.sort(releases, false);

        expect(result[0].protocol, 'usenet');
        expect(result[1].protocol, 'torrent');
      });

      test('within same type, sorted by releaseWeight ascending', () {
        final releases = [
          ReadarrRelease(
              title: 'T Heavy',
              protocol: 'torrent',
              releaseWeight: 10),
          ReadarrRelease(
              title: 'T Light',
              protocol: 'torrent',
              releaseWeight: 1),
        ];
        final result = ReadarrReleasesSorting.TYPE.sort(releases, true);

        expect(result[0].releaseWeight, 1);
        expect(result[1].releaseWeight, 10);
      });
    });

    group('sort - WEIGHT', () {
      test('sorts ascending by releaseWeight', () {
        final releases = [
          ReadarrRelease(title: 'Heavy', releaseWeight: 100),
          ReadarrRelease(title: 'Light', releaseWeight: 1),
          ReadarrRelease(title: 'Medium', releaseWeight: 50),
        ];
        final result = ReadarrReleasesSorting.WEIGHT.sort(releases, true);
        expect(result[0].releaseWeight, 1);
        expect(result[1].releaseWeight, 50);
        expect(result[2].releaseWeight, 100);
      });

      test('sorts descending by releaseWeight', () {
        final releases = [
          ReadarrRelease(title: 'Light', releaseWeight: 1),
          ReadarrRelease(title: 'Heavy', releaseWeight: 100),
          ReadarrRelease(title: 'Medium', releaseWeight: 50),
        ];
        final result = ReadarrReleasesSorting.WEIGHT.sort(releases, false);
        expect(result[0].releaseWeight, 100);
        expect(result[1].releaseWeight, 50);
        expect(result[2].releaseWeight, 1);
      });

      test('handles null releaseWeight (treated as -1)', () {
        final releases = [
          ReadarrRelease(title: 'Has Weight', releaseWeight: 5),
          ReadarrRelease(title: 'No Weight', releaseWeight: null),
        ];
        final result = ReadarrReleasesSorting.WEIGHT.sort(releases, true);
        expect(result[0].releaseWeight, isNull); // -1 sorts first
        expect(result[1].releaseWeight, 5);
      });
    });

    group('sort - empty and single element', () {
      test('sorting empty list returns empty for all types', () {
        for (final sortType in ReadarrReleasesSorting.values) {
          final result = sortType.sort([], true);
          expect(result, isEmpty,
              reason: '${sortType.name} should return empty for empty input');
        }
      });

      test('sorting single element returns single element for all types', () {
        final single = [
          ReadarrRelease(
            title: 'Only Release',
            ageHours: 5.0,
            size: 1000,
            releaseWeight: 10,
            seeders: 5,
            protocol: 'torrent',
            approved: true,
          ),
        ];
        for (final sortType in ReadarrReleasesSorting.values) {
          final result = sortType.sort(List.from(single), true);
          expect(result.length, 1,
              reason:
                  '${sortType.name} should return single element for single input');
          expect(result[0].title, 'Only Release');
        }
      });
    });

    group('ascending vs descending', () {
      test('ascending and descending produce reversed results for AGE', () {
        final releases = [
          ReadarrRelease(title: 'A', ageHours: 1.0),
          ReadarrRelease(title: 'B', ageHours: 2.0),
          ReadarrRelease(title: 'C', ageHours: 3.0),
        ];
        final asc =
            ReadarrReleasesSorting.AGE.sort(List.from(releases), true);
        final desc =
            ReadarrReleasesSorting.AGE.sort(List.from(releases), false);

        expect(asc.first.ageHours, 1.0);
        expect(desc.first.ageHours, 3.0);
        expect(asc.last.ageHours, 3.0);
        expect(desc.last.ageHours, 1.0);
      });

      test(
          'ascending and descending produce reversed results for ALPHABETICAL',
          () {
        final releases = [
          ReadarrRelease(title: 'Alpha'),
          ReadarrRelease(title: 'Beta'),
          ReadarrRelease(title: 'Gamma'),
        ];
        final asc = ReadarrReleasesSorting.ALPHABETICAL
            .sort(List.from(releases), true);
        final desc = ReadarrReleasesSorting.ALPHABETICAL
            .sort(List.from(releases), false);

        expect(asc.first.title, 'Alpha');
        expect(desc.first.title, 'Gamma');
      });

      test('ascending and descending produce reversed results for SIZE', () {
        final releases = [
          ReadarrRelease(title: 'A', size: 100),
          ReadarrRelease(title: 'B', size: 200),
          ReadarrRelease(title: 'C', size: 300),
        ];
        final asc =
            ReadarrReleasesSorting.SIZE.sort(List.from(releases), true);
        final desc =
            ReadarrReleasesSorting.SIZE.sort(List.from(releases), false);

        expect(asc.first.size, 100);
        expect(desc.first.size, 300);
      });

      test('ascending and descending produce reversed results for WEIGHT',
          () {
        final releases = [
          ReadarrRelease(title: 'A', releaseWeight: 1),
          ReadarrRelease(title: 'B', releaseWeight: 2),
          ReadarrRelease(title: 'C', releaseWeight: 3),
        ];
        final asc =
            ReadarrReleasesSorting.WEIGHT.sort(List.from(releases), true);
        final desc =
            ReadarrReleasesSorting.WEIGHT.sort(List.from(releases), false);

        expect(asc.first.releaseWeight, 1);
        expect(desc.first.releaseWeight, 3);
      });
    });
  });
}
