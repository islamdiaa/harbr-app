import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrColours {
  /// List of Harbr colours in order that the should appear in a list.
  ///
  /// Use [byListIndex] to fetch the colour at the any index
  static const _LIST_COLOR_ICONS = [
    blue,
    accent,
    red,
    orange,
    purple,
    blueGrey,
  ];

  /// Core accent colour — Harbr muted purple
  static const Color accent = Color(0xFF8B7FB8);

  /// Core primary colour (background) — deep purple
  static const Color primary = Color(0xFF3D3550);

  /// Core secondary colour (appbar, bottom bar, etc.) — purple-tinted
  static const Color secondary = Color(0xFF3D3550);

  static const Color blue = Color(0xFF00A8E8);
  static const Color blueGrey = Color(0xFF6E7B8B);
  static const Color grey = Color(0xFFADB5BD);
  static const Color orange = Color(0xFFFF9000);
  static const Color purple = Color(0xFF7C4DFF);
  static const Color red = Color(0xFFEF5350);

  /// Shades of White
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  /// Returns the correct colour for a graph by what layer it is on the graph canvas.
  Color byGraphLayer(int index) {
    switch (index) {
      case 0:
        return HarbrColours.accent;
      case 1:
        return HarbrColours.purple;
      case 2:
        return HarbrColours.blue;
      default:
        return byListIndex(index);
    }
  }

  /// Return the correct colour for a list.
  /// If the index is greater than the list of colour's length, uses modulus to loop list.
  Color byListIndex(int index) {
    return _LIST_COLOR_ICONS[index % _LIST_COLOR_ICONS.length];
  }
}

extension HarbrColor on Color {
  Color disabled([bool condition = true]) {
    if (condition) return this.withOpacity(HarbrUI.OPACITY_DISABLED);
    return this;
  }

  Color enabled([bool condition = true]) {
    if (condition) return this;
    return this.withOpacity(HarbrUI.OPACITY_DISABLED);
  }

  Color selected([bool condition = true]) {
    if (condition) return this.withOpacity(HarbrUI.OPACITY_SELECTED);
    return this;
  }

  Color dimmed() => this.withOpacity(HarbrUI.OPACITY_DIMMED);
}
