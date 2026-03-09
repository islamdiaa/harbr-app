import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/add_book/state.dart';
import 'package:harbr/modules/readarr/routes/add_book/widgets/appbar.dart';
import 'package:harbr/modules/readarr/routes/add_book/widgets/page_search.dart';

class ReadarrAddBookRoute extends StatefulWidget {
  final String query;

  const ReadarrAddBookRoute({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrAddBookRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadarrAddBookState(
        context,
        widget.query,
      ),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return ReadarrAddBookAppBar(
      scrollController: scrollController,
      query: widget.query,
      autofocus: widget.query.isEmpty,
    ) as PreferredSizeWidget;
  }

  Widget _body() {
    return ReadarrAddBookSearchPage(scrollController: scrollController);
  }
}
