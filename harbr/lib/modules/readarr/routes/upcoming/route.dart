import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/navigation_bar.dart';
import 'package:harbr/modules/readarr/routes/upcoming/widgets/upcoming_tile.dart';

class ReadarrUpcomingRoute extends StatefulWidget {
  const ReadarrUpcomingRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrUpcomingRoute> createState() => _State();
}

class _State extends State<ReadarrUpcomingRoute>
    with AutomaticKeepAliveClientMixin, HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    context.read<ReadarrState>().fetchAllBooks();
    await context.read<ReadarrState>().books;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      body: _body(),
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: Selector<ReadarrState, Future<List<ReadarrBook>>?>(
        selector: (_, state) => state.books,
        builder: (context, future, _) => FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<List<ReadarrBook>> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                HarbrLogger().error(
                  'Unable to fetch Readarr upcoming books',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (snapshot.hasData) return _books(snapshot.data!);
            return const HarbrLoader();
          },
        ),
      ),
    );
  }

  Widget _books(List<ReadarrBook> books) {
    // Filter to books with future release dates
    final now = DateTime.now();
    final futureDays = ReadarrDatabase.UPCOMING_FUTURE_DAYS.read();
    final cutoff = now.add(Duration(days: futureDays));

    List<ReadarrBook> upcoming = books.where((book) {
      if (book.releaseDate == null) return false;
      return book.releaseDate!.isAfter(now) &&
          book.releaseDate!.isBefore(cutoff);
    }).toList();

    upcoming.sort((a, b) => a.releaseDate!.compareTo(b.releaseDate!));

    if (upcoming.isEmpty) {
      return HarbrMessage(
        text: 'readarr.NoBooksFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState?.show,
      );
    }

    // Split books into days
    Map<String, Map<String, dynamic>> _bookMap =
        upcoming.fold({}, (map, entry) {
      String _date =
          DateFormat('y-MM-dd').format(entry.releaseDate!.toLocal());
      if (!map.containsKey(_date))
        map[_date] = {
          'date': DateFormat('EEEE / MMMM dd, y')
              .format(entry.releaseDate!.toLocal()),
          'entries': [],
        };
      (map[_date]!['entries'] as List).add(entry);
      return map;
    });

    List<List<Widget>> _bookWidgets = [];
    _bookMap.keys.toList()
      ..sort()
      ..forEach((key) {
        _bookWidgets.add(_buildDay(
          (_bookMap[key]!['date'] as String?),
          (_bookMap[key]!['entries'] as List).cast<ReadarrBook>(),
        ));
      });

    return HarbrListView(
      controller: ReadarrNavigationBar.scrollControllers[1],
      children: _bookWidgets.expand((e) => e).toList(),
    );
  }

  List<Widget> _buildDay(String? date, List<ReadarrBook> books) => [
        HarbrHeader(text: date),
        ...List.generate(
          books.length,
          (index) => ReadarrUpcomingTile(book: books[index]),
        ),
      ];
}
