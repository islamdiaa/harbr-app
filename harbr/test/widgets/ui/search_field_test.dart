import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/search_field.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrSearchField', () {
    testWidgets('renders with default hint text', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSearchField(),
      ));

      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('renders with custom hint text', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSearchField(hintText: 'Search movies...'),
      ));

      expect(find.text('Search movies...'), findsOneWidget);
    });

    testWidgets('has search icon prefix', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSearchField(),
      ));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? lastValue;

      await tester.pumpWidget(harbrTestApp(
        HarbrSearchField(
          onChanged: (value) => lastValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'hello');
      expect(lastValue, 'hello');
    });

    testWidgets('shows clear button when text is present', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSearchField(),
      ));

      // No clear button initially
      expect(find.byIcon(Icons.close_rounded), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('clear button removes text and calls onChanged', (tester) async {
      String? lastValue;

      await tester.pumpWidget(harbrTestApp(
        HarbrSearchField(
          onChanged: (value) => lastValue = value,
        ),
      ));

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(lastValue, '');
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('uses external controller when provided', (tester) async {
      final controller = TextEditingController(text: 'initial');

      await tester.pumpWidget(harbrTestApp(
        HarbrSearchField(controller: controller),
      ));

      // Should show the initial text
      expect(find.text('initial'), findsOneWidget);
      // Clear button should be visible since text is present
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      controller.dispose();
    });

    testWidgets('calls onSubmitted when submit is triggered', (tester) async {
      String? submittedValue;

      await tester.pumpWidget(harbrTestApp(
        HarbrSearchField(
          onSubmitted: (value) => submittedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'search query');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submittedValue, 'search query');
    });
  });
}
