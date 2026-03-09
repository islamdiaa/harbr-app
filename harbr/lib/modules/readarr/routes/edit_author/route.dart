import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/bottom_action_bar.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/tile_author_path.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/tile_metadata_profile.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/tile_monitored.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/tile_quality_profile.dart';
import 'package:harbr/modules/readarr/routes/edit_author/widgets/tile_tags.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ReadarrEditAuthorRoute extends StatefulWidget {
  final int authorId;

  const ReadarrEditAuthorRoute({
    Key? key,
    required this.authorId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrEditAuthorRoute>
    with HarbrLoadCallbackMixin, HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> loadCallback() async {
    context.read<ReadarrState>().fetchTags();
    context.read<ReadarrState>().fetchQualityProfiles();
    context.read<ReadarrState>().fetchMetadataProfiles();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.authorId <= 0)
      return InvalidRoutePage(
        title: 'readarr.EditAuthor'.tr(),
        message: 'readarr.AuthorNotFound'.tr(),
      );
    return ChangeNotifierProvider(
      create: (_) => ReadarrEditAuthorState(),
      builder: (context, _) {
        HarbrLoadingState state =
            context.select<ReadarrEditAuthorState, HarbrLoadingState>(
                (state) => state.state);
        return HarbrScaffold(
          scaffoldKey: _scaffoldKey,
          appBar: _appBar() as PreferredSizeWidget?,
          body:
              state == HarbrLoadingState.ERROR ? _bodyError() : _body(context),
          bottomNavigationBar: state == HarbrLoadingState.ERROR
              ? null
              : const ReadarrEditAuthorActionBar(),
        );
      },
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      scrollControllers: [scrollController],
      title: 'readarr.EditAuthor'.tr(),
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
      future: Future.wait([
        context.select<ReadarrState, Future<Map<int, ReadarrAuthor>>?>(
            (state) => state.authors)!,
        context.select<ReadarrState, Future<List<ReadarrQualityProfile>>?>(
            (state) => state.qualityProfiles)!,
        context.select<ReadarrState, Future<List<ReadarrMetadataProfile>>?>(
            (state) => state.metadataProfiles)!,
        context.select<ReadarrState, Future<List<ReadarrTag>>?>(
            (state) => state.tags)!,
      ]),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasError) {
          return HarbrMessage.error(onTap: loadCallback);
        }
        if (snapshot.hasData) {
          ReadarrAuthor? author =
              (snapshot.data![0] as Map)[widget.authorId];
          if (author == null) return const HarbrLoader();
          return _list(
            context,
            author: author,
            qualityProfiles:
                snapshot.data![1] as List<ReadarrQualityProfile>,
            metadataProfiles:
                snapshot.data![2] as List<ReadarrMetadataProfile>,
            tags: snapshot.data![3] as List<ReadarrTag>,
          );
        }
        return const HarbrLoader();
      },
    );
  }

  Widget _list(
    BuildContext context, {
    required ReadarrAuthor author,
    required List<ReadarrQualityProfile> qualityProfiles,
    required List<ReadarrMetadataProfile> metadataProfiles,
    required List<ReadarrTag> tags,
  }) {
    if (context.read<ReadarrEditAuthorState>().author == null) {
      context.read<ReadarrEditAuthorState>().author = author;
      context
          .read<ReadarrEditAuthorState>()
          .initializeQualityProfile(qualityProfiles);
      context
          .read<ReadarrEditAuthorState>()
          .initializeMetadataProfile(metadataProfiles);
      context.read<ReadarrEditAuthorState>().initializeTags(tags);
      context.read<ReadarrEditAuthorState>().canExecuteAction = true;
    }
    return HarbrListView(
      controller: scrollController,
      children: [
        const ReadarrEditAuthorMonitoredTile(),
        ReadarrEditAuthorQualityProfileTile(profiles: qualityProfiles),
        if (metadataProfiles.isNotEmpty)
          ReadarrEditAuthorMetadataProfileTile(profiles: metadataProfiles),
        const ReadarrEditAuthorPathTile(),
        const ReadarrEditAuthorTagsTile(),
      ],
    );
  }
}
