import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';

void main() {
  group('HarbrColors', () {
    group('Midnight surface layers', () {
      test('canvas is #1A1525', () {
        expect(HarbrColors.canvas, const Color(0xFF1A1525));
      });

      test('surface0 is #241E35', () {
        expect(HarbrColors.surface0, const Color(0xFF241E35));
      });

      test('surface1 is #2D2640', () {
        expect(HarbrColors.surface1, const Color(0xFF2D2640));
      });

      test('surface2 is #352E4A', () {
        expect(HarbrColors.surface2, const Color(0xFF352E4A));
      });

      test('surface3 is #4A4460', () {
        expect(HarbrColors.surface3, const Color(0xFF4A4460));
      });

      test('deepSurface is #130F1E', () {
        expect(HarbrColors.deepSurface, const Color(0xFF130F1E));
      });

      test('surface layers increase in lightness', () {
        // Each surface layer should be lighter than the previous
        expect(HarbrColors.canvas.computeLuminance(),
            lessThan(HarbrColors.surface0.computeLuminance()));
        expect(HarbrColors.surface0.computeLuminance(),
            lessThan(HarbrColors.surface1.computeLuminance()));
        expect(HarbrColors.surface1.computeLuminance(),
            lessThan(HarbrColors.surface2.computeLuminance()));
        expect(HarbrColors.surface2.computeLuminance(),
            lessThan(HarbrColors.surface3.computeLuminance()));
      });
    });

    group('AMOLED surface layers', () {
      test('amoledCanvas is pure black', () {
        expect(HarbrColors.amoledCanvas, const Color(0xFF000000));
      });

      test('amoledDeepSurface is pure black', () {
        expect(HarbrColors.amoledDeepSurface, const Color(0xFF000000));
      });

      test('AMOLED surfaces are darker than Midnight surfaces', () {
        expect(HarbrColors.amoledCanvas.computeLuminance(),
            lessThan(HarbrColors.canvas.computeLuminance()));
        expect(HarbrColors.amoledSurface0.computeLuminance(),
            lessThan(HarbrColors.surface0.computeLuminance()));
      });
    });

    group('Accent colors', () {
      test('accent is orange #F97316', () {
        expect(HarbrColors.accent, const Color(0xFFF97316));
      });

      test('accentDim is 15% alpha of accent', () {
        expect(HarbrColors.accentDim.a, closeTo(0x26 / 255, 0.01));
      });

      test('navActive is purple #8B5CF6', () {
        expect(HarbrColors.navActive, const Color(0xFF8B5CF6));
      });

      test('navActiveDim is 20% alpha of navActive', () {
        expect(HarbrColors.navActiveDim.a, closeTo(0x33 / 255, 0.01));
      });
    });

    group('Semantic status colors', () {
      test('success is green #22C55E', () {
        expect(HarbrColors.success, const Color(0xFF22C55E));
      });

      test('warning is yellow #EAB308', () {
        expect(HarbrColors.warning, const Color(0xFFEAB308));
      });

      test('danger is red #EF4444', () {
        expect(HarbrColors.danger, const Color(0xFFEF4444));
      });

      test('info is blue #3B82F6', () {
        expect(HarbrColors.info, const Color(0xFF3B82F6));
      });
    });

    group('Text colors', () {
      test('onSurface is near-white #F0EEF5', () {
        expect(HarbrColors.onSurface, const Color(0xFFF0EEF5));
      });

      test('onSurfaceDim is muted #9590A8', () {
        expect(HarbrColors.onSurfaceDim, const Color(0xFF9590A8));
      });

      test('onSurfaceFaint is faintest #5D5570', () {
        expect(HarbrColors.onSurfaceFaint, const Color(0xFF5D5570));
      });

      test('text colors decrease in luminance', () {
        expect(HarbrColors.onSurface.computeLuminance(),
            greaterThan(HarbrColors.onSurfaceDim.computeLuminance()));
        expect(HarbrColors.onSurfaceDim.computeLuminance(),
            greaterThan(HarbrColors.onSurfaceFaint.computeLuminance()));
      });
    });

    group('Border colors', () {
      test('border is transparent white at ~8%', () {
        expect(HarbrColors.border, const Color(0x14FFFFFF));
      });

      test('borderHigh is transparent white at ~16%', () {
        expect(HarbrColors.borderHigh, const Color(0x29FFFFFF));
      });

      test('borderHigh is more opaque than border', () {
        expect(HarbrColors.borderHigh.a, greaterThan(HarbrColors.border.a));
      });
    });

    group('byListIndex', () {
      test('returns colors cyclically', () {
        expect(HarbrColors.byListIndex(0), HarbrColors.listColors[0]);
        expect(HarbrColors.byListIndex(5), HarbrColors.listColors[5]);
      });

      test('wraps around after list length', () {
        final listLength = HarbrColors.listColors.length;
        expect(HarbrColors.byListIndex(listLength), HarbrColors.listColors[0]);
        expect(HarbrColors.byListIndex(listLength + 1), HarbrColors.listColors[1]);
      });

      test('list has 6 colors', () {
        expect(HarbrColors.listColors.length, 6);
      });
    });
  });
}
