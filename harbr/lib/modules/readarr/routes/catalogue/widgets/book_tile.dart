import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrCatalogueBookTile extends StatefulWidget {
  final ReadarrBook book;
  final Map<int, ReadarrAuthor>? authors;

  const ReadarrCatalogueBookTile({
    Key? key,
    required this.book,
    this.authors,
  }) : super(key: key);

  @override
  State<ReadarrCatalogueBookTile> createState() => _State();
}

class _State extends State<ReadarrCatalogueBookTile> {
  @override
  Widget build(BuildContext context) {
    Widget content = Opacity(
      opacity: (widget.book.monitored ?? true)
          ? 1.0
          : HarbrTokens.opacityDisabled,
      child: Row(
        children: [
          HarbrPoster(
            url: context.read<ReadarrState>().getBookCoverURL(widget.book),
            headers: context.read<ReadarrState>().headers,
            placeholderIcon: Icons.book_rounded,
            size: PosterSize.xl,
            overlayWidgets: [
              Positioned(
                bottom: 4,
                left: 4,
                child: _statusBadge(),
              ),
            ],
          ),
          const SizedBox(width: HarbrTokens.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title ?? HarbrUI.TEXT_EMDASH,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.harbr.onSurface,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getAuthorName(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.harbr.onSurfaceDim,
                    fontSize: 13.0,
                  ),
                ),
                if (widget.book.overview?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.book.overview!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.harbr.onSurfaceDim,
                      fontSize: 12.0,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Wrap(
                  spacing: HarbrTokens.xs,
                  runSpacing: HarbrTokens.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    HarbrStatusBadge(
                      type: widget.book.harbrIsMonitored
                          ? StatusType.monitored
                          : StatusType.unmonitored,
                    ),
                    HarbrMetaChip(
                      icon: Icons.menu_book_rounded,
                      label: widget.book.harbrPageCount,
                    ),
                    HarbrMetaChip(
                      icon: Icons.calendar_today,
                      label: widget.book.harbrReleaseDate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return HarbrSurface(
      showBorder: true,
      borderRadius: HarbrTokens.borderRadiusXxl,
      margin: HarbrTokens.paddingCard,
      padding: HarbrTokens.paddingMd,
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: content,
    );
  }

  Widget _statusBadge() {
    if (widget.book.harbrHasFile) {
      return const HarbrStatusBadge(type: StatusType.downloaded);
    }
    if (widget.book.harbrIsGrabbed) {
      return const HarbrStatusBadge(type: StatusType.queued);
    }
    return const HarbrStatusBadge(type: StatusType.missing);
  }

  String _getAuthorName() {
    // Try to get author name from the book's embedded author
    if (widget.book.author?.authorName?.isNotEmpty ?? false) {
      return widget.book.author!.authorName!;
    }
    // Fall back to looking up in the authors map
    if (widget.authors != null && widget.book.authorId != null) {
      final author = widget.authors![widget.book.authorId];
      if (author?.authorName?.isNotEmpty ?? false) {
        return author!.authorName!;
      }
    }
    return HarbrUI.TEXT_EMDASH;
  }

  Future<void> _onTap() async {
    ReadarrRoutes.BOOK.go(params: {
      'book': widget.book.id!.toString(),
    });
  }

  Future<void> _onLongPress() async {
    ReadarrAPIController().toggleBookMonitored(
      context: context,
      book: widget.book,
    );
  }
}
