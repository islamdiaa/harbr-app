import 'package:flutter/material.dart';

/// Harbr design tokens — single source of truth for spacing, radii, elevation,
/// opacity, and animation durations across the entire app.
abstract final class HarbrTokens {
  // ── Spacing scale ──────────────────────────────────────────────
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // Semantic aliases
  static const double xs = space4;
  static const double sm = space8;
  static const double md = space12;
  static const double lg = space16;
  static const double xl = space24;
  static const double xxl = space32;

  // ── Border radii ───────────────────────────────────────────────
  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 14.0;
  static const double radiusXl = 20.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusPill =
      BorderRadius.all(Radius.circular(radiusPill));

  // ── Opacity ────────────────────────────────────────────────────
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
  static const double opacitySplash = 0.12;
  static const double opacityHover = 0.08;

  // ── Animation durations ────────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationShimmer = Duration(milliseconds: 1000);

  // ── Icon sizes ─────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ── Common EdgeInsets ──────────────────────────────────────────
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingH =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingV =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingCard =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);

  // ── Responsive breakpoints ─────────────────────────────────────
  static const double breakpointCompact = 600.0;
  static const double breakpointMedium = 840.0;
  static const double breakpointExpanded = 1200.0;
}
