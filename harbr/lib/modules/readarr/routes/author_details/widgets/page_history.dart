import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/author_details/state.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/navigation_bar.dart';
import 'package:harbr/modules/readarr/routes/history/widgets/history_tile.dart';

class ReadarrAuthorDetailsHistoryPage extends StatefulWidget {
  const ReadarrAuthorDetailsHistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrAuthorDetailsHistoryPage> createState() => _State();
}

class _State extends State<ReadarrAuthorDetailsHistoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: context.watch<ReadarrAuthorDetailsState>().history,
      builder: (context, AsyncSnapshot<List<ReadarrHistoryRecord>> snapshot) {
        if (snapshot.hasError) {
          return HarbrMessage.error(onTap: () {
            context.read<ReadarrAuthorDetailsState>().fetchHistory(context);
          });
        }
        if (snapshot.hasData) return _list(snapshot.data!);
        return const HarbrLoader();
      },
    );
  }

  Widget _list(List<ReadarrHistoryRecord> history) {
    if (history.isEmpty) {
      return HarbrMessage(text: 'readarr.NoHistoryFound'.tr());
    }
    return HarbrListViewBuilder(
      controller: ReadarrAuthorDetailsNavigationBar.scrollControllers[2],
      itemCount: history.length,
      itemBuilder: (context, index) => ReadarrHistoryTile(
        history: history[index],
      ),
    );
  }
}
