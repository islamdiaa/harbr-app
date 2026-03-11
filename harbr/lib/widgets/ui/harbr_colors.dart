import 'package:flutter/material.dart';

/// Harbr semantic color system — Figma-aligned.
///
/// Provides surface layers, semantic status colors, and text colors
/// for both Midnight (default) and AMOLED themes.
abstract final class HarbrColors {
  // ── Surface layers (Midnight theme — Figma-aligned) ─────────────
  static const Color canvas = Color(0xFF1A1525);
  static const Color surface0 = Color(0xFF241E35);
  static const Color surface1 = Color(0xFF2D2640);
  static const Color surface2 = Color(0xFF352E4A);
  static const Color surface3 = Color(0xFF4A4460);
  static const Color deepSurface = Color(0xFF130F1E);

  // ── Surface layers (AMOLED theme) ──────────────────────────────
  static const Color amoledCanvas = Color(0xFF000000);
  static const Color amoledSurface0 = Color(0xFF0A0812);
  static const Color amoledSurface1 = Color(0xFF130F1E);
  static const Color amoledSurface2 = Color(0xFF1A1525);
  static const Color amoledSurface3 = Color(0xFF241E35);
  static const Color amoledDeepSurface = Color(0xFF000000);

  // ── Accent (orange — primary CTA) ────────────────────────────────
  static const Color accent = Color(0xFFF97316);
  static const Color accentDim = Color(0x26F97316); // 15%

  // ── Navigation active (purple — bottom nav / rail only) ──────────
  static const Color navActive = Color(0xFF8B5CF6);
  static const Color navActiveDim = Color(0x338B5CF6); // 20%

  // ── Semantic status ────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFEAB308);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Text / on-surface ──────────────────────────────────────────
  static const Color onSurface = Color(0xFFF0EEF5);
  static const Color onSurfaceDim = Color(0xFF9590A8);
  static const Color onSurfaceFaint = Color(0xFF5D5570);

  // ── Nav bar background ─────────────────────────────────────────
  static const Color navBarBg = Color(0xF21E1830); // #1E1830 at 95%
  static const Color navBarBorder = Color(0x0DFFFFFF); // white at 5%

  // ── Borders (transparent white) ─────────────────────────────────
  static const Color border = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color borderHigh = Color(0x29FFFFFF); // rgba(255,255,255,0.16)
  static const Color borderAccent = Color(0x33F97316); // 20% orange

  // ── Legacy compat (maps to old HarbrColours) ───────────────────
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueGrey = Color(0xFF6E7B8B);
  static const Color orange = Color(0xFFF97316);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color red = Color(0xFFEF4444);

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
