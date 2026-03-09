import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/author_details/state.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/appbar_settings_action.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/navigation_bar.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/page_books.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/page_history.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/page_overview.dart';
import 'package:harbr/router/routes/readarr.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ReadarrAuthorDetailsRoute extends StatefulWidget {
  final int authorId;

  const ReadarrAuthorDetailsRoute({
    Key? key,
    required this.authorId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrAuthorDetailsRoute>
    with HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ReadarrAuthor? author;
  PageController? _pageController;

  @override
  Future<void> loadCallback() async {
    if (widget.authorId > 0) {
      ReadarrAuthor? result =
          (await context.read<ReadarrState>().authors)![widget.authorId];
      setState(() => author = result);
      context.read<ReadarrState>().fetchQualityProfiles();
      context.read<ReadarrState>().fetchTags();
      await context.read<ReadarrState>().fetchAuthor(widget.authorId);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  List<ReadarrTag> _findTags(
    List<int>? tagIds,
    List<ReadarrTag> tags,
  ) {
    return tags.where((tag) => tagIds!.contains(tag.id)).toList();
  }

  ReadarrQualityProfile? _findQualityProfile(
    int? qualityProfileId,
    List<ReadarrQualityProfile> profiles,
  ) {
    return profiles.firstWhereOrNull(
      (profile) => profile.id == qualityProfileId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.authorId <= 0) {
      return InvalidRoutePage(
        title: 'readarr.AuthorDetails'.tr(),
        message: 'readarr.AuthorNotFound'.tr(),
      );
    }
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar:
          context.watch<ReadarrState>().enabled ? _bottomNavigationBar() : null,
      body: _body(),
    );
  }

  Widget _appBar() {
    List<Widget>? _actions;

    if (author != null) {
      _actions = [
        HarbrIconButton(
          icon: HarbrIcons.EDIT,
          onPressed: () {
            ReadarrRoutes.AUTHOR_EDIT.go(
              params: {'author': widget.authorId.toString()},
            );
          },
        ),
        ReadarrAuthorDetailsAppBarSettingsAction(authorId: widget.authorId),
      ];
    }
    return HarbrAppBar(
      title: 'readarr.AuthorDetails'.tr(),
      scrollControllers: ReadarrAuthorDetailsNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: _actions,
    );
  }

  Widget? _bottomNavigationBar() {
    if (author == null) return null;
    return ReadarrAuthorDetailsNavigationBar(
      pageController: _pageController,
    );
  }

  Widget _body() {
    return Consumer<ReadarrState>(
      builder: (context, state, _) => FutureBuilder(
        future: Future.wait([
          state.qualityProfiles!,
          state.tags!,
          state.authors!,
        ]),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to pull Readarr author details',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(onTap: loadCallback);
          }
          if (snapshot.hasData) {
            author =
                (snapshot.data![2] as Map<int, ReadarrAuthor>)[widget.authorId];
            if (author == null) {
              return HarbrMessage.goBack(
                text: 'readarr.AuthorNotFound'.tr(),
                context: context,
              );
            }
            ReadarrQualityProfile? quality = _findQualityProfile(
              author!.qualityProfileId,
              snapshot.data![0] as List<ReadarrQualityProfile>,
            );
            List<ReadarrTag> tags = _findTags(
              author!.tags,
              snapshot.data![1] as List<ReadarrTag>,
            );
            return _pages(
              qualityProfile: quality,
              tags: tags,
            );
          }
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _pages({
    required ReadarrQualityProfile? qualityProfile,
    required List<ReadarrTag> tags,
  }) {
    return ChangeNotifierProvider(
      create: (context) => ReadarrAuthorDetailsState(
        context: context,
        author: author!,
      ),
      builder: (context, _) => HarbrPageView(
        controller: _pageController,
        children: [
          ReadarrAuthorDetailsOverviewPage(
            author: author!,
            qualityProfile: qualityProfile,
            tags: tags,
          ),
          const ReadarrAuthorDetailsBooksPage(),
          const ReadarrAuthorDetailsHistoryPage(),
        ],
      ),
    );
  }
}
