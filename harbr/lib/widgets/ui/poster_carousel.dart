import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/poster.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A horizontal scrollable strip of poster images.
///
/// Each item displays a [HarbrPoster] with optional title and year below.
class HarbrPosterCarousel extends StatelessWidget {
  final List<HarbrPosterCarouselItem> items;
  final PosterSize posterSize;
  final ValueChanged<int>? onItemTap;

  const HarbrPosterCarousel({
    super.key,
    required this.items,
    this.posterSize = PosterSize.hero,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return SizedBox(
      height: _totalHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.md),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: HarbrTokens.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: onItemTap != null ? () => onItemTap!(index) : null,
            child: SizedBox(
              width: _posterWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HarbrPoster(
                    url: item.imageUrl,
                    headers: item.headers,
                    size: posterSize,
                    placeholderIcon: item.placeholderIcon,
                    overlayWidgets: item.overlayWidgets,
                  ),
                  if (item.title != null) ...[
                    const SizedBox(height: HarbrTokens.xs),
                    Text(
                      item.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: harbr.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: harbr.onSurfaceDim,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double get _posterHeight {
    switch (posterSize) {
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

  double get _posterWidth => _posterHeight / 1.5;

  double get _totalHeight => _posterHeight + 40; // room for title + subtitle
}

/// Data model for a single item in a [HarbrPosterCarousel].
class HarbrPosterCarouselItem {
  final String? imageUrl;
  final Map? headers;
  final String? title;
  final String? subtitle;
  final IconData? placeholderIcon;
  final List<Widget>? overlayWidgets;

  const HarbrPosterCarouselItem({
    this.imageUrl,
    this.headers,
    this.title,
    this.subtitle,
    this.placeholderIcon,
    this.overlayWidgets,
  });
}
