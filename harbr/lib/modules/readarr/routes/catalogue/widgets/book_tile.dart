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
    return HarbrMediaRow(
      poster: HarbrPoster(
        url: context.read<ReadarrState>().getBookCoverURL(widget.book),
        headers: context.read<ReadarrState>().headers,
        placeholderIcon: Icons.book_rounded,
        size: PosterSize.lg,
      ),
      title: widget.book.title ?? HarbrUI.TEXT_EMDASH,
      subtitle: _getAuthorName(),
      disabled: !(widget.book.monitored ?? true),
      status: _statusBadge(),
      metadata: [
        HarbrStatusBadge(
          type: widget.book.harbrIsMonitored
              ? StatusType.monitored
              : StatusType.unmonitored,
        ),
      ],
      onTap: _onTap,
      onLongPress: _onLongPress,
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
