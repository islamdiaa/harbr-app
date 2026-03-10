import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/status_badge.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrStatusBadge', () {
    group('renders all status types', () {
      for (final type in StatusType.values) {
        testWidgets('renders ${type.name} badge', (tester) async {
          await tester.pumpWidget(harbrTestApp(
            HarbrStatusBadge(type: type),
          ));

          // Should find the default label text
          expect(find.byType(HarbrStatusBadge), findsOneWidget);
          // Should contain an icon
          expect(find.byType(Icon), findsOneWidget);
        });
      }
    });

    group('default labels', () {
      testWidgets('downloaded shows "Complete"', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.downloaded),
        ));
        expect(find.text('Complete'), findsOneWidget);
      });

      testWidgets('missing shows "Missing"', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.missing),
        ));
        expect(find.text('Missing'), findsOneWidget);
      });

      testWidgets('upcoming shows "Upcoming"', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.upcoming),
        ));
        expect(find.text('Upcoming'), findsOneWidget);
      });

      testWidgets('queued shows "Queued"', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.queued),
        ));
        expect(find.text('Queued'), findsOneWidget);
      });

      testWidgets('error shows "Error"', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.error),
        ));
        expect(find.text('Error'), findsOneWidget);
      });
    });

    group('custom label', () {
      testWidgets('overrides default label', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(
            type: StatusType.upcoming,
            label: 'In Cinemas',
          ),
        ));
        expect(find.text('In Cinemas'), findsOneWidget);
        expect(find.text('Upcoming'), findsNothing);
      });
    });

    group('medium size', () {
      testWidgets('renders with larger padding', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.downloaded, medium: true),
        ));

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(HarbrStatusBadge),
            matching: find.byType(Container),
          ),
        );
        final padding = container.padding as EdgeInsets;
        expect(padding.left, 12.0);
        expect(padding.top, 4.0);
      });

      testWidgets('small size has smaller padding', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.downloaded),
        ));

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(HarbrStatusBadge),
            matching: find.byType(Container),
          ),
        );
        final padding = container.padding as EdgeInsets;
        expect(padding.left, 8.0);
        expect(padding.top, 2.0);
      });
    });

    group('icons per status type', () {
      testWidgets('downloaded has check circle icon', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.downloaded),
        ));
        expect(
          find.byIcon(Icons.check_circle_outline_rounded),
          findsOneWidget,
        );
      });

      testWidgets('missing has error outline icon', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.missing),
        ));
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      });

      testWidgets('upcoming has schedule icon', (tester) async {
        await tester.pumpWidget(harbrTestApp(
          const HarbrStatusBadge(type: StatusType.upcoming),
        ));
        expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
      });
    });
  });
}
