import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAddBookSearchResultTile extends StatelessWidget {
  final ReadarrBook book;
  final bool onTapShowOverview;
  final bool exists;

  const ReadarrAddBookSearchResultTile({
    Key? key,
    required this.book,
    this.onTapShowOverview = false,
    this.exists = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      posterUrl: context.read<ReadarrState>().getBookCoverURL(book),
      posterHeaders: context.read<ReadarrState>().headers,
      posterPlaceholderIcon: Icons.book_rounded,
      disabled: exists,
      title: book.title ?? HarbrUI.TEXT_EMDASH,
      body: [
        TextSpan(text: book.harbrAuthorTitle),
        TextSpan(
          text: exists ? 'readarr.AlreadyInLibrary'.tr() : book.harbrReleaseDate,
          style: TextStyle(
            color: exists ? HarbrColours.accent : null,
            fontWeight: exists ? HarbrUI.FONT_WEIGHT_BOLD : null,
          ),
        ),
      ],
      onTap: exists
          ? null
          : () {
              if (onTapShowOverview) {
                HarbrDialogs().textPreview(
                  context,
                  book.title ?? HarbrUI.TEXT_EMDASH,
                  book.harbrOverview ?? '',
                );
              } else {
                ReadarrRoutes.ADD_BOOK_DETAILS.go(extra: book);
              }
            },
    );
  }
}
