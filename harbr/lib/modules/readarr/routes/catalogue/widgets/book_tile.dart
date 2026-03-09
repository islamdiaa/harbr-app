import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrCatalogueBookTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(2);

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
    return HarbrBlock(
      posterUrl: context.read<ReadarrState>().getBookCoverURL(widget.book),
      posterHeaders: context.read<ReadarrState>().headers,
      posterPlaceholderIcon: Icons.book_rounded,
      disabled: !(widget.book.monitored ?? true),
      title: widget.book.title ?? HarbrUI.TEXT_EMDASH,
      body: [
        _subtitle1(),
        _subtitle2(),
      ],
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  TextSpan _subtitle1() {
    String authorName = _getAuthorName();
    return TextSpan(
      children: [
        TextSpan(text: authorName),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.book.harbrFileStatus,
          style: TextStyle(
            color: widget.book.harbrHasFile
                ? HarbrColours.accent
                : widget.book.harbrIsGrabbed
                    ? HarbrColours.orange
                    : HarbrColours.red,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(
          text: widget.book.harbrIsMonitored
              ? 'readarr.Monitored'.tr()
              : 'readarr.Unmonitored'.tr(),
          style: TextStyle(
            color: widget.book.harbrIsMonitored
                ? HarbrColours.accent
                : HarbrColours.red,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      ],
    );
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
