import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

void main() {
  group('HarbrThemeData', () {
    group('midnight preset', () {
      test('uses Midnight surface colors', () {
        expect(HarbrThemeData.midnight.canvas, HarbrColors.canvas);
        expect(HarbrThemeData.midnight.surface0, HarbrColors.surface0);
        expect(HarbrThemeData.midnight.surface1, HarbrColors.surface1);
        expect(HarbrThemeData.midnight.surface2, HarbrColors.surface2);
        expect(HarbrThemeData.midnight.surface3, HarbrColors.surface3);
        expect(HarbrThemeData.midnight.deepSurface, HarbrColors.deepSurface);
      });

      test('uses correct accent colors', () {
        expect(HarbrThemeData.midnight.accent, HarbrColors.accent);
        expect(HarbrThemeData.midnight.accentDim, HarbrColors.accentDim);
      });

      test('uses correct nav-active colors', () {
        expect(HarbrThemeData.midnight.navActive, HarbrColors.navActive);
        expect(HarbrThemeData.midnight.navActiveDim, HarbrColors.navActiveDim);
      });

      test('uses correct semantic colors', () {
        expect(HarbrThemeData.midnight.success, HarbrColors.success);
        expect(HarbrThemeData.midnight.warning, HarbrColors.warning);
        expect(HarbrThemeData.midnight.danger, HarbrColors.danger);
        expect(HarbrThemeData.midnight.info, HarbrColors.info);
      });

      test('uses standard border', () {
        expect(HarbrThemeData.midnight.border, HarbrColors.border);
      });
    });

    group('amoled preset', () {
      test('uses AMOLED surface colors', () {
        expect(HarbrThemeData.amoled.canvas, HarbrColors.amoledCanvas);
        expect(HarbrThemeData.amoled.surface0, HarbrColors.amoledSurface0);
        expect(HarbrThemeData.amoled.deepSurface, HarbrColors.amoledDeepSurface);
      });

      test('uses borderHigh for more visibility on black', () {
        expect(HarbrThemeData.amoled.border, HarbrColors.borderHigh);
      });

      test('shares same accent as midnight', () {
        expect(HarbrThemeData.amoled.accent, HarbrThemeData.midnight.accent);
        expect(HarbrThemeData.amoled.navActive, HarbrThemeData.midnight.navActive);
      });

      test('shares same semantic colors as midnight', () {
        expect(HarbrThemeData.amoled.success, HarbrThemeData.midnight.success);
        expect(HarbrThemeData.amoled.danger, HarbrThemeData.midnight.danger);
      });
    });

    group('copyWith', () {
      test('returns identical when no overrides', () {
        final copy = HarbrThemeData.midnight.copyWith();
        expect(copy.canvas, HarbrThemeData.midnight.canvas);
        expect(copy.accent, HarbrThemeData.midnight.accent);
        expect(copy.navActive, HarbrThemeData.midnight.navActive);
        expect(copy.onSurface, HarbrThemeData.midnight.onSurface);
      });

      test('overrides single field', () {
        final copy = HarbrThemeData.midnight.copyWith(canvas: Colors.red);
        expect(copy.canvas, Colors.red);
        expect(copy.surface0, HarbrThemeData.midnight.surface0);
        expect(copy.accent, HarbrThemeData.midnight.accent);
      });

      test('overrides navActive independently', () {
        final copy = HarbrThemeData.midnight.copyWith(navActive: Colors.green);
        expect(copy.navActive, Colors.green);
        expect(copy.accent, HarbrThemeData.midnight.accent);
      });

      test('overrides multiple fields', () {
        final copy = HarbrThemeData.midnight.copyWith(
          canvas: Colors.blue,
          accent: Colors.yellow,
          navActive: Colors.green,
        );
        expect(copy.canvas, Colors.blue);
        expect(copy.accent, Colors.yellow);
        expect(copy.navActive, Colors.green);
        expect(copy.surface0, HarbrThemeData.midnight.surface0);
      });
    });

    group('lerp', () {
      test('t=0.0 returns this', () {
        final result = HarbrThemeData.midnight.lerp(HarbrThemeData.amoled, 0.0);
        expect(result.canvas, HarbrThemeData.midnight.canvas);
        expect(result.surface0, HarbrThemeData.midnight.surface0);
      });

      test('t=1.0 returns other', () {
        final result = HarbrThemeData.midnight.lerp(HarbrThemeData.amoled, 1.0);
        expect(result.canvas, HarbrThemeData.amoled.canvas);
        expect(result.surface0, HarbrThemeData.amoled.surface0);
      });

      test('t=0.5 produces intermediate colors', () {
        final result = HarbrThemeData.midnight.lerp(HarbrThemeData.amoled, 0.5);
        // Canvas should be between midnight and amoled values
        expect(result.canvas, isNot(HarbrThemeData.midnight.canvas));
        expect(result.canvas, isNot(HarbrThemeData.amoled.canvas));
      });

      test('returns this when other is null', () {
        final result = HarbrThemeData.midnight.lerp(null, 0.5);
        expect(result.canvas, HarbrThemeData.midnight.canvas);
      });
    });

    group('HarbrThemeContext extension', () {
      testWidgets('returns midnight theme from context', (tester) async {
        late HarbrThemeData resolvedTheme;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              extensions: const [HarbrThemeData.midnight],
            ),
            home: Builder(
              builder: (context) {
                resolvedTheme = context.harbr;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(resolvedTheme.canvas, HarbrColors.canvas);
        expect(resolvedTheme.accent, HarbrColors.accent);
      });

      testWidgets('falls back to midnight when no extension registered',
          (tester) async {
        late HarbrThemeData resolvedTheme;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Builder(
              builder: (context) {
                resolvedTheme = context.harbr;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(resolvedTheme.canvas, HarbrThemeData.midnight.canvas);
      });
    });
  });
}
