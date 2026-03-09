import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/book_details/sheets/links.dart';
import 'package:harbr/modules/readarr/routes/book_details/state.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/appbar_settings_action.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/navigation_bar.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/page_history.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/page_overview.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ReadarrBookDetailsRoute extends StatefulWidget {
  final int bookId;

  const ReadarrBookDetailsRoute({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrBookDetailsRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController? _pageController;
  ReadarrBook? _book;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookId <= 0) {
      return InvalidRoutePage(
        title: 'readarr.BookDetails'.tr(),
        message: 'readarr.BookNotFound'.tr(),
      );
    }
    return ChangeNotifierProvider(
      create: (context) => ReadarrBookDetailsState(
        context: context,
        bookId: widget.bookId,
      ),
      builder: (context, _) {
        return FutureBuilder(
          future: context.watch<ReadarrBookDetailsState>().book,
          builder: (context, AsyncSnapshot<ReadarrBook> snapshot) {
            _book = snapshot.data;
            return HarbrScaffold(
              scaffoldKey: _scaffoldKey,
              module: HarbrModule.READARR,
              appBar: _appBar(),
              body: _body(context, snapshot),
              bottomNavigationBar:
                  _book != null ? _bottomNavigationBar() : null,
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    List<Widget>? _actions;

    if (_book != null) {
      _actions = [
        HarbrIconButton(
          icon: HarbrIcons.LINK,
          onPressed: () async {
            ReadarrBookDetailsLinksSheet(book: _book!).show();
          },
        ),
        ReadarrBookDetailsAppBarSettingsAction(bookId: widget.bookId),
      ];
    }

    return HarbrAppBar(
      title: 'readarr.BookDetails'.tr(),
      scrollControllers: ReadarrBookDetailsNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: _actions,
    );
  }

  Widget? _bottomNavigationBar() {
    return ReadarrBookDetailsNavigationBar(
      pageController: _pageController,
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<ReadarrBook> snapshot) {
    if (snapshot.hasError) {
      if (snapshot.connectionState != ConnectionState.waiting) {
        HarbrLogger().error(
          'Unable to fetch Readarr book details',
          snapshot.error,
          snapshot.stackTrace,
        );
      }
      return HarbrMessage.error(
        onTap: () {
          context.read<ReadarrBookDetailsState>().fetchBook(context);
          context.read<ReadarrBookDetailsState>().fetchHistory(context);
        },
      );
    }
    if (snapshot.hasData) return _pages(snapshot.data!);
    return const HarbrLoader();
  }

  Widget _pages(ReadarrBook book) {
    return HarbrPageView(
      controller: _pageController,
      children: [
        ReadarrBookDetailsOverviewPage(book: book),
        const ReadarrBookDetailsHistoryPage(),
      ],
    );
  }
}
