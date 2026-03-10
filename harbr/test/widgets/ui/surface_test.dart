import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('SurfaceLevel', () {
    test('has 5 values', () {
      expect(SurfaceLevel.values.length, 5);
    });

    test('values are in order: deep, canvas, base, raised, overlay', () {
      expect(SurfaceLevel.values[0], SurfaceLevel.deep);
      expect(SurfaceLevel.values[1], SurfaceLevel.canvas);
      expect(SurfaceLevel.values[2], SurfaceLevel.base);
      expect(SurfaceLevel.values[3], SurfaceLevel.raised);
      expect(SurfaceLevel.values[4], SurfaceLevel.overlay);
    });
  });

  group('HarbrSurface', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSurface(
          child: Text('Hello'),
        ),
      ));

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('defaults to SurfaceLevel.base', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSurface(
          child: Text('Test'),
        ),
      ));

      // Should use surface0 color for base level
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(HarbrSurface),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, HarbrColors.surface0);
    });

    testWidgets('fires onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(harbrTestApp(
        HarbrSurface(
          onTap: () => tapped = true,
          child: const Text('Tap me'),
        ),
      ));

      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('fires onLongPress callback', (tester) async {
      bool longPressed = false;

      await tester.pumpWidget(harbrTestApp(
        HarbrSurface(
          onLongPress: () => longPressed = true,
          child: const Text('Long press me'),
        ),
      ));

      await tester.longPress(find.text('Long press me'));
      expect(longPressed, isTrue);
    });

    testWidgets('applies padding when provided', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSurface(
          padding: EdgeInsets.all(20),
          child: Text('Padded'),
        ),
      ));

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('shows border when showBorder is true', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSurface(
          showBorder: true,
          child: Text('Bordered'),
        ),
      ));

      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    testWidgets('no border by default', (tester) async {
      await tester.pumpWidget(harbrTestApp(
        const HarbrSurface(
          child: Text('No border'),
        ),
      ));

      // DecoratedBox is not used when showBorder is false
      expect(find.byType(DecoratedBox), findsNothing);
    });

    group('surface level color mapping', () {
      for (final level in SurfaceLevel.values) {
        testWidgets('renders $level without error', (tester) async {
          await tester.pumpWidget(harbrTestApp(
            HarbrSurface(
              level: level,
              child: Text(level.name),
            ),
          ));

          expect(find.text(level.name), findsOneWidget);
        });
      }
    });
  });
}
