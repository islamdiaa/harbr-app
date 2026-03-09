import 'package:flutter/material.dart';

/// Harbr semantic color system.
///
/// Provides surface layers, semantic status colors, and text colors
/// for both Midnight (default) and AMOLED themes.
abstract final class HarbrColors {
  // ── Surface layers (Midnight theme) ────────────────────────────
  static const Color canvas = Color(0xFF0D1117);
  static const Color surface0 = Color(0xFF161B22);
  static const Color surface1 = Color(0xFF1C2128);
  static const Color surface2 = Color(0xFF242A33);
  static const Color surface3 = Color(0xFF2D333B);

  // ── Surface layers (AMOLED theme) ──────────────────────────────
  static const Color amoledCanvas = Color(0xFF000000);
  static const Color amoledSurface0 = Color(0xFF000000);
  static const Color amoledSurface1 = Color(0xFF0D1117);
  static const Color amoledSurface2 = Color(0xFF161B22);
  static const Color amoledSurface3 = Color(0xFF1C2128);

  // ── Accent ─────────────────────────────────────────────────────
  static const Color accent = Color(0xFF00BCD4);
  static const Color accentDim = Color(0x2600BCD4); // 15%

  // ── Semantic status ────────────────────────────────────────────
  static const Color success = Color(0xFF3FB950);
  static const Color warning = Color(0xFFD29922);
  static const Color danger = Color(0xFFF85149);
  static const Color info = Color(0xFF58A6FF);

  // ── Text / on-surface ──────────────────────────────────────────
  static const Color onSurface = Color(0xFFE6EDF3);
  static const Color onSurfaceDim = Color(0xFF8B949E);
  static const Color onSurfaceFaint = Color(0xFF484F58);

  // ── Borders ────────────────────────────────────────────────────
  static const Color border = Color(0x0FFFFFFF); // 6%
  static const Color borderHigh = Color(0x1AFFFFFF); // 10%
  static const Color borderAccent = Color(0x3300BCD4); // 20%

  // ── Legacy compat (maps to old HarbrColours) ───────────────────
  static const Color blue = Color(0xFF00A8E8);
  static const Color blueGrey = Color(0xFF6E7B8B);
  static const Color orange = Color(0xFFFF9000);
  static const Color purple = Color(0xFF7C4DFF);
  static const Color red = Color(0xFFF85149);

  /// Cycle through colors for list item icons.
  static const List<Color> listColors = [
    blue,
    accent,
    red,
    orange,
    purple,
    blueGrey,
  ];

  static Color byListIndex(int index) =>
      listColors[index % listColors.length];
}
