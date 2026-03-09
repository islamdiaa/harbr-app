import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrUpcomingTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(2);

  final ReadarrBook book;

  const ReadarrUpcomingTile({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<ReadarrUpcomingTile> createState() => _State();
}

class _State extends State<ReadarrUpcomingTile> {
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
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      text: widget.book.harbrAuthorTitle,
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      text: widget.book.releaseDate != null
          ? DateFormat('MMMM dd, y')
              .format(widget.book.releaseDate!.toLocal())
          : 'harbr.Unknown'.tr(),
      style: const TextStyle(
        color: HarbrColours.accent,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        fontSize: HarbrUI.FONT_SIZE_H3,
      ),
    );
  }

  Future<void> _onTap() async {
    if (widget.book.authorId != null) {
      ReadarrRoutes.AUTHOR.go(params: {
        'author': widget.book.authorId!.toString(),
      });
    }
  }
}
