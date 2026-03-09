import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/tags/widgets/appbar_action_add_tag.dart';
import 'package:harbr/modules/readarr/routes/tags/widgets/tag_tile.dart';

class ReadarrTagsRoute extends StatefulWidget {
  const ReadarrTagsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrTagsRoute>
    with HarbrScrollControllerMixin, HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<ReadarrState>().fetchTags();
    await context.read<ReadarrState>().tags;
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'Tags',
      scrollControllers: [scrollController],
      actions: const [
        ReadarrTagsAppBarActionAddTag(),
      ],
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: FutureBuilder(
        future: context.watch<ReadarrState>().tags,
        builder: (context, AsyncSnapshot<List<ReadarrTag>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to fetch Readarr tags',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) return _list(snapshot.data);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(List<ReadarrTag>? tags) {
    if ((tags?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'readarr.NoTagsFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState?.show,
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: tags!.length,
      itemBuilder: (context, index) => ReadarrTagsTile(
        key: ObjectKey(tags[index].id),
        tag: tags[index],
      ),
    );
  }
}
