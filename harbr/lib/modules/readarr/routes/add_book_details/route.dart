import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/bottom_action_bar.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/tile_metadata_profile.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/tile_monitored.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/tile_quality_profile.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/tile_root_folder.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/widgets/tile_tags.dart';

class ReadarrAddBookDetailsRoute extends StatefulWidget {
  final ReadarrBook? book;

  const ReadarrAddBookDetailsRoute({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrAddBookDetailsRoute>
    with HarbrLoadCallbackMixin, HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<ReadarrState>().fetchRootFolders();
    context.read<ReadarrState>().fetchTags();
    context.read<ReadarrState>().fetchQualityProfiles();
    context.read<ReadarrState>().fetchMetadataProfiles();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.book == null) {
      return HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: HarbrAppBar(
          title: 'readarr.AddBook'.tr(),
          scrollControllers: [scrollController],
        ) as PreferredSizeWidget?,
        body: HarbrMessage.goBack(
          context: context,
          text: 'harbr.InvalidRoute'.tr(),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (_) => ReadarrAddBookDetailsState(book: widget.book!),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(context),
        bottomNavigationBar: const ReadarrAddBookDetailsActionBar(),
      ),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'readarr.AddBook'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
        [
          context.watch<ReadarrState>().rootFolders!,
          context.watch<ReadarrState>().tags!,
          context.watch<ReadarrState>().qualityProfiles!,
          context.watch<ReadarrState>().metadataProfiles!,
        ],
      ),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasError) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            HarbrLogger().error(
              'Unable to fetch Readarr add book data',
              snapshot.error,
              snapshot.stackTrace,
            );
          }
          return HarbrMessage.error(onTap: () => _refreshKey.currentState?.show());
        }
        if (snapshot.hasData) {
          return _content(
            context,
            rootFolders: snapshot.data![0] as List<ReadarrRootFolder>,
            tags: snapshot.data![1] as List<ReadarrTag>,
            qualityProfiles:
                snapshot.data![2] as List<ReadarrQualityProfile>,
            metadataProfiles:
                snapshot.data![3] as List<ReadarrMetadataProfile>,
          );
        }
        return const HarbrLoader();
      },
    );
  }

  Widget _content(
    BuildContext context, {
    required List<ReadarrRootFolder> rootFolders,
    required List<ReadarrQualityProfile> qualityProfiles,
    required List<ReadarrMetadataProfile> metadataProfiles,
    required List<ReadarrTag> tags,
  }) {
    final addState = context.read<ReadarrAddBookDetailsState>();
    addState.initializeMonitored();
    addState.initializeRootFolder(rootFolders);
    addState.initializeQualityProfile(qualityProfiles);
    addState.initializeMetadataProfile(metadataProfiles);
    addState.initializeTags(tags);
    if (!addState.canExecuteAction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addState.canExecuteAction = true;
      });
    }
    return HarbrListView(
      controller: scrollController,
      children: const [
        ReadarrAddBookDetailsRootFolderTile(),
        ReadarrAddBookDetailsMonitoredTile(),
        ReadarrAddBookDetailsQualityProfileTile(),
        ReadarrAddBookDetailsMetadataProfileTile(),
        ReadarrAddBookDetailsTagsTile(),
      ],
    );
  }
}
