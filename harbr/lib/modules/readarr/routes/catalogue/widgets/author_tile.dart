import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAuthorTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(2);

  final ReadarrAuthor author;
  final ReadarrQualityProfile? profile;

  const ReadarrAuthorTile({
    Key? key,
    required this.author,
    required this.profile,
  }) : super(key: key);

  @override
  State<ReadarrAuthorTile> createState() => _State();
}

class _State extends State<ReadarrAuthorTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<ReadarrState, Future<Map<int, ReadarrAuthor>>?>(
      selector: (_, state) => state.authors,
      builder: (context, authors, _) => _buildBlockTile(),
    );
  }

  Widget _buildBlockTile() {
    return HarbrBlock(
      posterUrl:
          context.read<ReadarrState>().getAuthorPosterURL(widget.author),
      posterHeaders: context.read<ReadarrState>().headers,
      posterPlaceholderIcon: Icons.person_rounded,
      disabled: !widget.author.monitored!,
      title: widget.author.authorName,
      body: [
        _subtitle1(),
        _subtitle2(),
      ],
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(text: widget.author.harbrBookProgress),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.author.harbrSizeOnDisk),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.profile?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      ],
    );
  }

  Future<void> _onTap() async {
    ReadarrRoutes.AUTHOR.go(params: {
      'author': widget.author.id!.toString(),
    });
  }

  Future<void> _onLongPress() async {
    ReadarrAPIController().toggleAuthorMonitored(
      context: context,
      author: widget.author,
    );
  }
}
