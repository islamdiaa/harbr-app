import 'package:flutter/material.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/widgets/ui.dart';

class ReadarrBookDetailsLinksSheet extends HarbrBottomModalSheet {
  final ReadarrBook book;

  ReadarrBookDetailsLinksSheet({
    required this.book,
  });

  @override
  Widget builder(BuildContext context) {
    final links = book.links ?? [];

    if (links.isEmpty) {
      return HarbrListViewModal(
        children: [
          HarbrMessage(text: 'No Links Available'),
        ],
      );
    }

    return HarbrListViewModal(
      children: links
          .where((link) => link.url != null && link.url!.isNotEmpty)
          .map(
            (link) => HarbrBlock(
              title: link.name ?? 'Link',
              leading: const HarbrIconButton(icon: HarbrIcons.LINK),
              onTap: () => link.url!.openLink(),
            ),
          )
          .toList(),
    );
  }
}
