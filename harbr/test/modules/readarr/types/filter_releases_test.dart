import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/api/readarr/models/release/release.dart';
import 'package:harbr/modules/readarr/core/types/filter_releases.dart';

void main() {
  group('ReadarrReleasesFilter', () {
    group('enum values', () {
      test('has exactly 3 values', () {
        expect(ReadarrReleasesFilter.values.length, 3);
      });

      test('contains ALL, APPROVED, REJECTED', () {
        expect(ReadarrReleasesFilter.values,
            contains(ReadarrReleasesFilter.ALL));
        expect(ReadarrReleasesFilter.values,
            contains(ReadarrReleasesFilter.APPROVED));
        expect(ReadarrReleasesFilter.values,
            contains(ReadarrReleasesFilter.REJECTED));
      });
    });

    group('key', () {
      test('ALL has key "all"', () {
        expect(ReadarrReleasesFilter.ALL.key, 'all');
      });

      test('APPROVED has key "approved"', () {
        expect(ReadarrReleasesFilter.APPROVED.key, 'approved');
      });

      test('REJECTED has key "rejected"', () {
        expect(ReadarrReleasesFilter.REJECTED.key, 'rejected');
      });

      test('all keys are unique', () {
        final keys =
            ReadarrReleasesFilter.values.map((f) => f.key).toSet();
        expect(keys.length, ReadarrReleasesFilter.values.length);
      });
    });

    group('readable', () {
      test('ALL readable returns non-empty string', () {
        expect(ReadarrReleasesFilter.ALL.readable, isNotEmpty);
      });

      test('APPROVED readable returns non-empty string', () {
        expect(ReadarrReleasesFilter.APPROVED.readable, isNotEmpty);
      });

      test('REJECTED readable returns non-empty string', () {
        expect(ReadarrReleasesFilter.REJECTED.readable, isNotEmpty);
      });

      test('all readable values are non-empty', () {
        for (final filter in ReadarrReleasesFilter.values) {
          expect(filter.readable, isNotEmpty,
              reason: '${filter.name} should have a non-empty readable');
        }
      });
    });

    group('fromKey', () {
      test('maps "all" to ALL', () {
        expect(ReadarrReleasesFilter.ALL.fromKey('all'),
            ReadarrReleasesFilter.ALL);
      });

      test('maps "approved" to APPROVED', () {
        expect(ReadarrReleasesFilter.ALL.fromKey('approved'),
            ReadarrReleasesFilter.APPROVED);
      });

      test('maps "rejected" to REJECTED', () {
        expect(ReadarrReleasesFilter.ALL.fromKey('rejected'),
            ReadarrReleasesFilter.REJECTED);
      });

      test('returns null for unknown key', () {
        expect(ReadarrReleasesFilter.ALL.fromKey('invalid'), isNull);
      });

      test('returns null for empty string', () {
        expect(ReadarrReleasesFilter.ALL.fromKey(''), isNull);
      });

      test('round-trips: fromKey(key) returns same filter', () {
        for (final filter in ReadarrReleasesFilter.values) {
          expect(filter.fromKey(filter.key), filter);
        }
      });
    });

    group('filter', () {
      late List<ReadarrRelease> releases;

      setUp(() {
        releases = [
          ReadarrRelease(
            title: 'Approved Release 1',
            approved: true,
            rejected: false,
          ),
          ReadarrRelease(
            title: 'Rejected Release 1',
            approved: false,
            rejected: true,
          ),
          ReadarrRelease(
            title: 'Approved Release 2',
            approved: true,
            rejected: false,
          ),
          ReadarrRelease(
            title: 'Rejected Release 2',
            approved: false,
            rejected: true,
          ),
          ReadarrRelease(
            title: 'Approved Release 3',
            approved: true,
            rejected: false,
          ),
        ];
      });

      group('ALL filter', () {
        test('returns all releases', () {
          final result = ReadarrReleasesFilter.ALL.filter(releases);
          expect(result.length, 5);
        });

        test('returns same list reference', () {
          final result = ReadarrReleasesFilter.ALL.filter(releases);
          expect(identical(result, releases), true);
        });

        test('returns empty list for empty input', () {
          final result = ReadarrReleasesFilter.ALL.filter([]);
          expect(result, isEmpty);
        });
      });

      group('APPROVED filter', () {
        test('returns only approved releases', () {
          final result = ReadarrReleasesFilter.APPROVED.filter(releases);
          expect(result.length, 3);
          expect(result.every((r) => r.approved == true), true);
        });

        test('returned releases have correct titles', () {
          final result = ReadarrReleasesFilter.APPROVED.filter(releases);
          final titles = result.map((r) => r.title).toList();
          expect(titles, contains('Approved Release 1'));
          expect(titles, contains('Approved Release 2'));
          expect(titles, contains('Approved Release 3'));
        });

        test('returns empty when no approved releases', () {
          final allRejected = [
            ReadarrRelease(title: 'R1', approved: false),
            ReadarrRelease(title: 'R2', approved: false),
          ];
          final result = ReadarrReleasesFilter.APPROVED.filter(allRejected);
          expect(result, isEmpty);
        });

        test('returns empty for empty input', () {
          final result = ReadarrReleasesFilter.APPROVED.filter([]);
          expect(result, isEmpty);
        });
      });

      group('REJECTED filter', () {
        test('returns only rejected (non-approved) releases', () {
          final result = ReadarrReleasesFilter.REJECTED.filter(releases);
          expect(result.length, 2);
          expect(result.every((r) => r.approved == false), true);
        });

        test('returned releases have correct titles', () {
          final result = ReadarrReleasesFilter.REJECTED.filter(releases);
          final titles = result.map((r) => r.title).toList();
          expect(titles, contains('Rejected Release 1'));
          expect(titles, contains('Rejected Release 2'));
        });

        test('returns empty when all approved', () {
          final allApproved = [
            ReadarrRelease(title: 'A1', approved: true),
            ReadarrRelease(title: 'A2', approved: true),
          ];
          final result = ReadarrReleasesFilter.REJECTED.filter(allApproved);
          expect(result, isEmpty);
        });

        test('returns empty for empty input', () {
          final result = ReadarrReleasesFilter.REJECTED.filter([]);
          expect(result, isEmpty);
        });
      });

      group('edge cases', () {
        test('single approved release - ALL returns 1', () {
          final single = [ReadarrRelease(title: 'Only', approved: true)];
          expect(ReadarrReleasesFilter.ALL.filter(single).length, 1);
        });

        test('single approved release - APPROVED returns 1', () {
          final single = [ReadarrRelease(title: 'Only', approved: true)];
          expect(ReadarrReleasesFilter.APPROVED.filter(single).length, 1);
        });

        test('single approved release - REJECTED returns 0', () {
          final single = [ReadarrRelease(title: 'Only', approved: true)];
          expect(ReadarrReleasesFilter.REJECTED.filter(single).length, 0);
        });

        test('single rejected release - REJECTED returns 1', () {
          final single = [ReadarrRelease(title: 'Only', approved: false)];
          expect(ReadarrReleasesFilter.REJECTED.filter(single).length, 1);
        });

        test('single rejected release - APPROVED returns 0', () {
          final single = [ReadarrRelease(title: 'Only', approved: false)];
          expect(ReadarrReleasesFilter.APPROVED.filter(single).length, 0);
        });
      });
    });
  });
}
