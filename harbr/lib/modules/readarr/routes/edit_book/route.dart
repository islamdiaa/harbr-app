import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_book/state.dart';
import 'package:harbr/modules/readarr/routes/edit_book/widgets/bottom_action_bar.dart';
import 'package:harbr/modules/readarr/routes/edit_book/widgets/tile_monitored.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ReadarrEditBookRoute extends StatefulWidget {
  final int bookId;

  const ReadarrEditBookRoute({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrEditBookRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.bookId <= 0)
      return InvalidRoutePage(
        title: 'readarr.EditBook'.tr(),
        message: 'readarr.BookNotFound'.tr(),
      );
    return ChangeNotifierProvider(
      create: (_) => ReadarrEditBookState(),
      builder: (context, _) {
        HarbrLoadingState state =
            context.select<ReadarrEditBookState, HarbrLoadingState>(
                (state) => state.state);
        return HarbrScaffold(
          scaffoldKey: _scaffoldKey,
          appBar: _appBar() as PreferredSizeWidget?,
          body:
              state == HarbrLoadingState.ERROR ? _bodyError() : _body(context),
          bottomNavigationBar: state == HarbrLoadingState.ERROR
              ? null
              : const ReadarrEditBookActionBar(),
        );
      },
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      scrollControllers: [scrollController],
      title: 'readarr.EditBook'.tr(),
    );
  }

  Widget _bodyError() {
    return HarbrMessage.goBack(
      context: context,
      text: 'harbr.AnErrorHasOccurred'.tr(),
    );
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<ReadarrState>()
          .api!
          .book
          .get(bookId: widget.bookId),
      builder: (context, AsyncSnapshot<ReadarrBook> snapshot) {
        if (snapshot.hasError) {
          return HarbrMessage.error(onTap: () => setState(() {}));
        }
        if (snapshot.hasData) {
          return _list(context, book: snapshot.data!);
        }
        return const HarbrLoader();
      },
    );
  }

  Widget _list(
    BuildContext context, {
    required ReadarrBook book,
  }) {
    if (context.read<ReadarrEditBookState>().book == null) {
      context.read<ReadarrEditBookState>().book = book;
      context.read<ReadarrEditBookState>().canExecuteAction = true;
    }
    return HarbrListView(
      controller: scrollController,
      children: const [
        ReadarrEditBookMonitoredTile(),
      ],
    );
  }
}
