import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/author_details/state.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/book_tile.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/navigation_bar.dart';

class ReadarrAuthorDetailsBooksPage extends StatefulWidget {
  const ReadarrAuthorDetailsBooksPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrAuthorDetailsBooksPage> createState() => _State();
}

class _State extends State<ReadarrAuthorDetailsBooksPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: context.watch<ReadarrAuthorDetailsState>().books,
      builder: (context, AsyncSnapshot<List<ReadarrBook>> snapshot) {
        if (snapshot.hasError) {
          return HarbrMessage.error(onTap: () {
            context.read<ReadarrAuthorDetailsState>().fetchBooks(context);
          });
        }
        if (snapshot.hasData) return _list(snapshot.data!);
        return const HarbrLoader();
      },
    );
  }

  Widget _list(List<ReadarrBook> books) {
    if (books.isEmpty) {
      return HarbrMessage(text: 'readarr.NoBooksFound'.tr());
    }
    return HarbrListViewBuilder(
      controller: ReadarrAuthorDetailsNavigationBar.scrollControllers[1],
      itemCount: books.length,
      itemBuilder: (context, index) => ReadarrAuthorDetailsBookTile(
        book: books[index],
      ),
    );
  }
}
