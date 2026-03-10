import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/harbr_nav_rail.dart';
import 'package:harbr/widgets/ui/pill_nav_bar.dart';

import '../../helpers/test_helpers.dart';

void main() {
  const destinations = [
    HarbrNavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    HarbrNavDestination(
      icon: Icons.video_library_outlined,
      selectedIcon: Icons.video_library_rounded,
      label: 'Library',
    ),
    HarbrNavDestination(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today_rounded,
      label: 'Calendar',
    ),
    HarbrNavDestination(
      icon: Icons.download_outlined,
      selectedIcon: Icons.download_rounded,
      label: 'Activities',
    ),
  ];

  group('HarbrPillNavBar', () {
    testWidgets('renders all 4 destination labels', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: destinations,
        ),
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Activities'), findsOneWidget);
    });

    testWidgets('calls onDestinationSelected with correct index on tap',
        (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (index) => tappedIndex = index,
          destinations: destinations,
        ),
      ));

      // Tap on "Library" (index 1)
      await tester.tap(find.text('Library'));
      expect(tappedIndex, 1);

      // Tap on "Calendar" (index 2)
      await tester.tap(find.text('Calendar'));
      expect(tappedIndex, 2);

      // Tap on "Activities" (index 3)
      await tester.tap(find.text('Activities'));
      expect(tappedIndex, 3);
    });

    testWidgets('shows selected icon for active tab', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: destinations,
        ),
      ));

      // Home is selected, should show filled icon
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      // Library is not selected, should show outlined icon
      expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
    });

    testWidgets('shows badge count when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: destinations,
          badgeCounts: const {3: 5},
        ),
      ));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('badge count capped at 99+', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: destinations,
          badgeCounts: const {3: 150},
        ),
      ));

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('no badge when count is 0', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        HarbrPillNavBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: destinations,
          badgeCounts: const {3: 0},
        ),
      ));

      // Should not find any badge text
      expect(find.text('0'), findsNothing);
    });

    testWidgets('switching selected index changes active tab', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return harbrTestApp(
              HarbrPillNavBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() => selectedIndex = index);
                },
                destinations: destinations,
              ),
            );
          },
        ),
      );

      // Initially Home is selected
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);

      // Tap Calendar
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();

      // Now Calendar should show selected icon
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
    });
  });
}
