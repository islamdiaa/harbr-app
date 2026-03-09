import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book/state.dart';
import 'package:harbr/modules/readarr/routes/add_book/widgets/search_results_tile.dart';

class ReadarrAddBookSearchPage extends StatefulWidget {
  final ScrollController scrollController;

  const ReadarrAddBookSearchPage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ReadarrAddBookSearchPage> createState() => _State();
}

class _State extends State<ReadarrAddBookSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Selector<ReadarrAddBookState, Future<List<ReadarrBook>>?>(
      selector: (_, state) => state.lookup,
      builder: (context, lookup, _) {
        if (lookup == null) {
          return HarbrMessage(
            text: 'readarr.SearchForBooks'.tr(),
          );
        }
        return FutureBuilder(
          future: lookup,
          builder: (context, AsyncSnapshot<List<ReadarrBook>> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                HarbrLogger().error(
                  'Unable to search for books',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return HarbrMessage.error(
                onTap: () =>
                    context.read<ReadarrAddBookState>().fetchLookup(context),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return HarbrMessage(
                  text: 'readarr.NoBooksFound'.tr(),
                );
              }
              return HarbrListViewBuilder(
                controller: widget.scrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ReadarrAddBookSearchResultTile(
                    book: snapshot.data![index],
                  );
                },
              );
            }
            return const HarbrLoader();
          },
        );
      },
    );
  }
}
