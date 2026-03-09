import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/book_description_tile.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/book_information_block.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/navigation_bar.dart';

class ReadarrBookDetailsOverviewPage extends StatefulWidget {
  final ReadarrBook book;

  const ReadarrBookDetailsOverviewPage({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<ReadarrBookDetailsOverviewPage> createState() => _State();
}

class _State extends State<ReadarrBookDetailsOverviewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrListView(
      controller: ReadarrBookDetailsNavigationBar.scrollControllers[0],
      children: [
        ReadarrBookInformationBlock(book: widget.book),
        ReadarrBookDescriptionTile(book: widget.book),
      ],
    );
  }
}
