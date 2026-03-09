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
    return HarbrMediaRow(
      poster: HarbrPoster(
        url: context.read<ReadarrState>().getBookCoverURL(book),
        headers: context.read<ReadarrState>().headers,
        placeholderIcon: Icons.book_rounded,
        size: PosterSize.lg,
      ),
      title: book.title ?? HarbrUI.TEXT_EMDASH,
      subtitle: book.harbrAuthorTitle,
      status: _statusBadge(),
      metadata: _metaChips(),
      disabled: exists,
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

  Widget? _statusBadge() {
    if (exists) {
      return const HarbrStatusBadge(
        type: StatusType.monitored,
        label: 'In Library',
      );
    }
    return null;
  }

  List<Widget> _metaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.calendar_today_rounded,
        label: book.harbrReleaseDate,
      ),
      if (book.pageCount != null && book.pageCount! > 0)
        HarbrMetaChip(
          icon: Icons.menu_book_rounded,
          label: book.harbrPageCount,
        ),
      if (book.editions != null && book.editions!.isNotEmpty)
        HarbrMetaChip(
          icon: Icons.layers_rounded,
          label: '${book.harbrEditionCount} editions',
        ),
    ];
  }
}
