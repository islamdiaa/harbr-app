import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/media_row.dart';
import 'package:harbr/widgets/ui/tokens.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrMediaRow', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(title: 'The Matrix'),
      ));

      expect(find.text('The Matrix'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          subtitle: '1999 . Action, Sci-Fi',
        ),
      ));

      expect(find.text('1999 . Action, Sci-Fi'), findsOneWidget);
    });

    testWidgets('does not render subtitle when null', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(title: 'The Matrix'),
      ));

      // Only one text widget (the title)
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, 1);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          description: 'A computer hacker learns about the true nature of reality.',
        ),
      ));

      expect(
        find.text('A computer hacker learns about the true nature of reality.'),
        findsOneWidget,
      );
    });

    testWidgets('renders status widget when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          status: Chip(label: Text('Complete')),
        ),
      ));

      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('renders metadata chips when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          metadata: [
            Text('1999'),
            Text('2h 16m'),
          ],
        ),
      ));

      expect(find.text('1999'), findsOneWidget);
      expect(find.text('2h 16m'), findsOneWidget);
    });

    testWidgets('renders trailing widget when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          trailing: Icon(Icons.chevron_right_rounded),
        ),
      ));

      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('fires onTap callback when enabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(harbrTestApp(
        HarbrMediaRow(
          title: 'The Matrix',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('The Matrix'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('does not fire onTap when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(harbrTestApp(
        HarbrMediaRow(
          title: 'The Matrix',
          onTap: () => tapped = true,
          disabled: true,
        ),
      ));

      await tester.tap(find.text('The Matrix'));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('applies reduced opacity when disabled', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'The Matrix',
          disabled: true,
        ),
      ));

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, HarbrTokens.opacityDisabled);
    });

    testWidgets('no Opacity widget when not disabled', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(title: 'The Matrix'),
      ));

      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('renders all elements together', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrMediaRow(
          title: 'Avatar',
          subtitle: '2009 . James Cameron',
          description: 'A paraplegic Marine dispatched to the moon Pandora.',
          status: Text('Complete'),
          metadata: [Text('2h 42m')],
          trailing: Icon(Icons.arrow_forward),
        ),
      ));

      expect(find.text('Avatar'), findsOneWidget);
      expect(find.text('2009 . James Cameron'), findsOneWidget);
      expect(find.text('A paraplegic Marine dispatched to the moon Pandora.'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
      expect(find.text('2h 42m'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });
}
