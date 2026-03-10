import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/images/network_image.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// Predefined poster size presets.
///
/// Each preset defines a fixed height; width is derived from a 2:3
/// aspect ratio (height / 1.5) unless [HarbrPoster.isSquare] is true.
enum PosterSize {
  /// 40 logical pixels tall.
  sm,

  /// 56 logical pixels tall (default).
  md,

  /// 72 logical pixels tall.
  lg,

  /// 96 logical pixels tall.
  xl,

  /// 192 logical pixels tall — hero detail screens.
  hero,
}

/// A standalone poster image widget with size presets and a built-in
/// placeholder fallback.
///
/// Wraps [HarbrNetworkImage] and adds consistent sizing, rounding,
/// and a themed placeholder icon when no [url] is provided.
class HarbrPoster extends StatelessWidget {
  /// Remote image URL. When `null` or empty, the placeholder is shown.
  final String? url;

  /// Optional HTTP headers forwarded to the image provider.
  final Map? headers;

  /// Icon displayed inside the placeholder when no image is available.
  final IconData? placeholderIcon;

  /// Logical size preset controlling the poster height.
  final PosterSize size;

  /// When `true` the poster is rendered as a square instead of using
  /// the default 2:3 aspect ratio.
  final bool isSquare;

  /// Custom border radius. Defaults to [HarbrTokens.borderRadiusSm].
  final BorderRadius? borderRadius;

  /// Optional widgets overlaid on top of the poster (e.g. status pills).
  final List<Widget>? overlayWidgets;

  const HarbrPoster({
    super.key,
    this.url,
    this.headers,
    this.placeholderIcon,
    this.size = PosterSize.md,
    this.isSquare = false,
    this.borderRadius,
    this.overlayWidgets,
  });

  /// Maps [PosterSize] to its logical pixel height.
  double get _height {
    switch (size) {
      case PosterSize.sm:
        return 40.0;
      case PosterSize.md:
        return 56.0;
      case PosterSize.lg:
        return 72.0;
      case PosterSize.xl:
        return 96.0;
      case PosterSize.hero:
        return 192.0;
    }
  }

  /// Width derived from height, respecting [isSquare].
  double get _width => isSquare ? _height : _height / 1.5;

  BorderRadius get _borderRadius =>
      borderRadius ?? HarbrTokens.borderRadiusSm;

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return ClipRRect(
      borderRadius: _borderRadius,
      child: SizedBox(
        height: _height,
        width: _width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Placeholder background — always rendered behind the image.
            Container(
              height: _height,
              width: _width,
              decoration: BoxDecoration(
                color: harbr.surface2,
              ),
              child: placeholderIcon != null
                  ? Center(
                      child: Icon(
                        placeholderIcon,
                        color: harbr.onSurfaceFaint,
                        size: _width * 0.40,
                      ),
                    )
                  : null,
            ),
            // Network image — fades in over the placeholder.
            if (url?.isNotEmpty ?? false)
              HarbrNetworkImage(
                context: context,
                url: url,
                headers: headers,
                placeholderIcon: placeholderIcon,
                height: _height,
                width: _width,
              ),
            // Overlay widgets (e.g. status pills, quality tags).
            if (overlayWidgets != null) ...overlayWidgets!,
          ],
        ),
      ),
    );
  }
}
