import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrMissingTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(2);

  final ReadarrMissingRecord record;

  const ReadarrMissingTile({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<ReadarrMissingTile> createState() => _State();
}

class _State extends State<ReadarrMissingTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      posterPlaceholderIcon: Icons.book_rounded,
      disabled: !(widget.record.monitored ?? false),
      title: widget.record.title ?? HarbrUI.TEXT_EMDASH,
      body: [
        _subtitle1(),
        _subtitle2(),
      ],
      onTap: _onTap,
      trailing: _trailing(),
    );
  }

  Widget _trailing() {
    return HarbrIconButton(
      icon: Icons.search_rounded,
      onPressed: _trailingOnTap,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.record.author?.authorName ?? 'harbr.Unknown'.tr(),
        ),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      style: const TextStyle(
        fontSize: HarbrUI.FONT_SIZE_H3,
        color: HarbrColours.red,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
      children: [
        TextSpan(
          text: widget.record.releaseDate == null
              ? 'Released'
              : 'Released ${widget.record.releaseDate!.toLocal().asAge()}',
        ),
      ],
    );
  }

  Future<void> _onTap() async {
    if (widget.record.authorId != null) {
      ReadarrRoutes.AUTHOR.go(params: {
        'author': widget.record.authorId!.toString(),
      });
    }
  }

  Future<void> _trailingOnTap() async {
    if (widget.record.id != null) {
      Provider.of<ReadarrState>(context, listen: false)
          .api!
          .command
          .bookSearch(bookId: widget.record.id!)
          .then((_) => showHarbrSuccessSnackBar(
                title: 'readarr.SearchingForBook'.tr(),
                message: widget.record.title,
              ))
          .catchError((error, stack) {
        HarbrLogger().error(
          'Failed to search for book: ${widget.record.id}',
          error,
          stack,
        );
        showHarbrErrorSnackBar(
          title: 'readarr.FailedToSearch'.tr(),
          error: error,
        );
      });
    }
  }
}
