import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harbr/widgets/ui/tokens.dart';

void main() {
  group('HarbrTokens', () {
    group('Spacing scale', () {
      test('raw values are in ascending order', () {
        expect(HarbrTokens.space2, 2.0);
        expect(HarbrTokens.space4, 4.0);
        expect(HarbrTokens.space6, 6.0);
        expect(HarbrTokens.space8, 8.0);
        expect(HarbrTokens.space12, 12.0);
        expect(HarbrTokens.space16, 16.0);
        expect(HarbrTokens.space20, 20.0);
        expect(HarbrTokens.space24, 24.0);
        expect(HarbrTokens.space32, 32.0);
        expect(HarbrTokens.space48, 48.0);
      });

      test('semantic aliases map to correct raw values', () {
        expect(HarbrTokens.xs, HarbrTokens.space4);
        expect(HarbrTokens.sm, HarbrTokens.space8);
        expect(HarbrTokens.md, HarbrTokens.space12);
        expect(HarbrTokens.lg, HarbrTokens.space16);
        expect(HarbrTokens.xl, HarbrTokens.space24);
        expect(HarbrTokens.xxl, HarbrTokens.space32);
      });
    });

    group('Border radii', () {
      test('radius values are in ascending order', () {
        expect(HarbrTokens.radiusSm, lessThan(HarbrTokens.radiusMd));
        expect(HarbrTokens.radiusMd, lessThan(HarbrTokens.radius12));
        expect(HarbrTokens.radius12, lessThan(HarbrTokens.radiusLg));
        expect(HarbrTokens.radiusLg, lessThan(HarbrTokens.radiusXl));
        expect(HarbrTokens.radiusXl, lessThan(HarbrTokens.radiusXxl));
        expect(HarbrTokens.radiusXxl, lessThan(HarbrTokens.radiusPill));
      });

      test('radius12 is 12.0 (Figma rounded-xl)', () {
        expect(HarbrTokens.radius12, 12.0);
      });

      test('radiusPill is 999.0 for full-round', () {
        expect(HarbrTokens.radiusPill, 999.0);
      });

      test('BorderRadius constants match their radius values', () {
        expect(
          HarbrTokens.borderRadiusSm,
          BorderRadius.all(Radius.circular(HarbrTokens.radiusSm)),
        );
        expect(
          HarbrTokens.borderRadius12,
          BorderRadius.all(Radius.circular(HarbrTokens.radius12)),
        );
        expect(
          HarbrTokens.borderRadiusPill,
          BorderRadius.all(Radius.circular(HarbrTokens.radiusPill)),
        );
      });
    });

    group('Opacity values', () {
      test('all opacities are between 0 and 1', () {
        expect(HarbrTokens.opacityDisabled, inInclusiveRange(0.0, 1.0));
        expect(HarbrTokens.opacityMedium, inInclusiveRange(0.0, 1.0));
        expect(HarbrTokens.opacityHigh, inInclusiveRange(0.0, 1.0));
        expect(HarbrTokens.opacitySplash, inInclusiveRange(0.0, 1.0));
        expect(HarbrTokens.opacityHover, inInclusiveRange(0.0, 1.0));
      });

      test('disabled < medium < high', () {
        expect(HarbrTokens.opacityDisabled, lessThan(HarbrTokens.opacityMedium));
        expect(HarbrTokens.opacityMedium, lessThan(HarbrTokens.opacityHigh));
      });
    });

    group('Animation durations', () {
      test('fast < normal < slow', () {
        expect(HarbrTokens.durationFast.inMilliseconds,
            lessThan(HarbrTokens.durationNormal.inMilliseconds));
        expect(HarbrTokens.durationNormal.inMilliseconds,
            lessThan(HarbrTokens.durationSlow.inMilliseconds));
      });

      test('durations have expected values', () {
        expect(HarbrTokens.durationFast, const Duration(milliseconds: 150));
        expect(HarbrTokens.durationNormal, const Duration(milliseconds: 250));
        expect(HarbrTokens.durationSlow, const Duration(milliseconds: 400));
        expect(HarbrTokens.durationShimmer, const Duration(milliseconds: 1000));
      });
    });

    group('Icon sizes', () {
      test('sizes are in ascending order', () {
        expect(HarbrTokens.iconSm, lessThan(HarbrTokens.iconMd));
        expect(HarbrTokens.iconMd, lessThan(HarbrTokens.iconLg));
        expect(HarbrTokens.iconLg, lessThan(HarbrTokens.iconXl));
      });

      test('expected values', () {
        expect(HarbrTokens.iconSm, 16.0);
        expect(HarbrTokens.iconMd, 20.0);
        expect(HarbrTokens.iconLg, 24.0);
        expect(HarbrTokens.iconXl, 32.0);
      });
    });

    group('Common EdgeInsets', () {
      test('paddingSm uses sm value', () {
        expect(HarbrTokens.paddingSm, EdgeInsets.all(HarbrTokens.sm));
      });

      test('paddingCard uses horizontal md, vertical sm', () {
        expect(
          HarbrTokens.paddingCard,
          const EdgeInsets.symmetric(
            horizontal: HarbrTokens.md,
            vertical: HarbrTokens.sm,
          ),
        );
      });
    });

    group('Responsive breakpoints', () {
      test('breakpoints are in ascending order', () {
        expect(HarbrTokens.breakpointCompact,
            lessThan(HarbrTokens.breakpointMedium));
        expect(HarbrTokens.breakpointMedium,
            lessThan(HarbrTokens.breakpointExpanded));
      });

      test('compact is 600', () {
        expect(HarbrTokens.breakpointCompact, 600.0);
      });
    });
  });
}
