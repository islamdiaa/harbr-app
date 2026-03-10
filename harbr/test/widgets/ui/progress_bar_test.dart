import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/progress_bar.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HarbrProgressBar', () {
    testWidgets('renders with default height of 4px', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 0.5),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 4.0);
    });

    testWidgets('renders with custom height', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 0.5, height: 8.0),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 8.0);
    });

    testWidgets('clamps progress to 0.0 for negative values', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: -0.5),
      ));

      final fractionBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionBox.widthFactor, 0.0);
    });

    testWidgets('clamps progress to 1.0 for values above 1', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 1.5),
      ));

      final fractionBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionBox.widthFactor, 1.0);
    });

    testWidgets('uses exact progress value for normal range', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 0.75),
      ));

      final fractionBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionBox.widthFactor, 0.75);
    });

    testWidgets('renders 0% progress', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 0.0),
      ));

      final fractionBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionBox.widthFactor, 0.0);
    });

    testWidgets('renders 100% progress', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 1.0),
      ));

      final fractionBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionBox.widthFactor, 1.0);
    });

    testWidgets('uses custom color when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(progress: 0.5, color: Colors.red),
      ));

      // Should render without errors
      expect(find.byType(HarbrProgressBar), findsOneWidget);
    });

    testWidgets('uses gradient when gradientColors provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrProgressBar(
          progress: 0.5,
          gradientColors: [Colors.orange, Colors.red],
        ),
      ));

      // Should render without errors
      expect(find.byType(HarbrProgressBar), findsOneWidget);
    });
  });
}
