import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAuthorDetailsBookTile extends StatelessWidget {
  final ReadarrBook book;

  const ReadarrAuthorDetailsBookTile({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      posterUrl: context.read<ReadarrState>().getBookCoverURL(book),
      posterHeaders: context.read<ReadarrState>().headers,
      posterPlaceholderIcon: Icons.book_rounded,
      disabled: !(book.monitored ?? true),
      title: book.title ?? HarbrUI.TEXT_EMDASH,
      body: [
        TextSpan(text: book.harbrReleaseDate),
        TextSpan(
          text: book.harbrIsMonitored
              ? 'readarr.Monitored'.tr()
              : 'readarr.Unmonitored'.tr(),
          style: TextStyle(
            color: book.harbrIsMonitored ? HarbrColours.accent : HarbrColours.red,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      ],
      onTap: () => ReadarrRoutes.BOOK.go(params: {
        'book': book.id!.toString(),
      }),
      onLongPress: () =>
          ReadarrAPIController().toggleBookMonitored(
            context: context,
            book: book,
          ),
    );
  }
}
