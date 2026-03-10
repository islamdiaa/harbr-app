import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/collapsible_section.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrCollapsibleSection', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Overview',
          child: Text('Content'),
        ),
      ));

      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('shows content when initially expanded', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Details',
          initiallyExpanded: true,
          child: Text('Detailed content here'),
        ),
      ));

      expect(find.text('Detailed content here'), findsOneWidget);
    });

    testWidgets('hides content when initially collapsed', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Details',
          initiallyExpanded: false,
          child: Text('Hidden content'),
        ),
      ));

      // The SizeTransition with factor 0 renders the widget but clips it
      // The widget tree still contains it but it should have zero height
      expect(find.byType(SizeTransition), findsOneWidget);
      final sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(sizeTransition.sizeFactor.value, 0.0);
    });

    testWidgets('toggles content on tap', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Toggle Me',
          initiallyExpanded: true,
          child: Text('Toggleable content'),
        ),
      ));

      // Initially expanded
      expect(find.text('Toggleable content'), findsOneWidget);

      // Tap the header to collapse
      await tester.tap(find.text('Toggle Me'));
      await tester.pumpAndSettle();

      // Content should now be collapsed (SizeTransition factor = 0)
      final sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(sizeTransition.sizeFactor.value, 0.0);
    });

    testWidgets('tap collapsed section expands it', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Expand Me',
          initiallyExpanded: false,
          child: Text('Now visible'),
        ),
      ));

      // Initially collapsed
      var sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(sizeTransition.sizeFactor.value, 0.0);

      // Tap to expand
      await tester.tap(find.text('Expand Me'));
      await tester.pumpAndSettle();

      // Now expanded
      sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(sizeTransition.sizeFactor.value, 1.0);
    });

    testWidgets('shows chevron icon', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Test',
          child: Text('Content'),
        ),
      ));

      expect(
        find.byIcon(Icons.keyboard_arrow_down_rounded),
        findsOneWidget,
      );
    });

    testWidgets('renders headerTrailing when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'With Trailing',
          headerTrailing: Icon(Icons.info_rounded),
          child: Text('Content'),
        ),
      ));

      expect(find.byIcon(Icons.info_rounded), findsOneWidget);
    });

    testWidgets('does not render headerTrailing when null', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrCollapsibleSection(
          title: 'Without Trailing',
          child: Text('Content'),
        ),
      ));

      expect(find.byIcon(Icons.info_rounded), findsNothing);
    });
  });
}
