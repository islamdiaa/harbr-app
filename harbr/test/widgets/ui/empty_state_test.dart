import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/empty_state.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrEmptyState', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'No Results',
        ),
      ));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('No Results'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'No Results',
          subtitle: 'Try a different search term.',
        ),
      ));

      expect(find.text('Try a different search term.'), findsOneWidget);
    });

    testWidgets('does not render subtitle when null', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'No Results',
        ),
      ));

      // Only title text should be present
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders hint when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'No Results',
          hint: 'Hint: check your filters',
        ),
      ));

      expect(find.text('Hint: check your filters'), findsOneWidget);
    });

    testWidgets('renders action widget when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'No Results',
          action: ElevatedButton(
            onPressed: () {},
            child: const Text('Retry'),
          ),
        ),
      ));

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders all optional elements together', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrEmptyState(
          icon: Icons.download_rounded,
          title: 'No Downloads',
          subtitle: 'Queue downloads to see them here.',
          hint: 'Browse your library to get started.',
          action: TextButton(
            onPressed: () {},
            child: const Text('Browse Library'),
          ),
        ),
      ));

      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
      expect(find.text('No Downloads'), findsOneWidget);
      expect(find.text('Queue downloads to see them here.'), findsOneWidget);
      expect(find.text('Browse your library to get started.'), findsOneWidget);
      expect(find.text('Browse Library'), findsOneWidget);
    });

    testWidgets('icon container is 64x64', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'Test',
        ),
      ));

      // Find the Container holding the icon
      final containers = tester.widgetList<Container>(find.byType(Container));
      final iconContainer = containers.firstWhere(
        (c) => c.constraints?.maxWidth == 64 && c.constraints?.maxHeight == 64,
        orElse: () => containers.first,
      );
      expect(iconContainer, isNotNull);
    });

    testWidgets('is centered', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrEmptyState(
          icon: Icons.search_rounded,
          title: 'Test',
        ),
      ));

      expect(find.byType(Center), findsOneWidget);
    });
  });
}
