import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationSearchEditIndexerRoute extends StatefulWidget {
  final int id;

  const ConfigurationSearchEditIndexerRoute({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ConfigurationSearchEditIndexerRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchEditIndexerRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrIndexer? _indexer;

  @override
  Widget build(BuildContext context) {
    if (widget.id < 0 || !HarbrBox.indexers.contains(widget.id)) {
      return InvalidRoutePage(
        title: 'search.EditIndexer'.tr(),
        message: 'search.IndexerNotFound'.tr(),
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'search.EditIndexer'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'search.DeleteIndexer'.tr(),
          icon: Icons.delete_rounded,
          color: HarbrColours.red,
          onTap: () async {
            bool result = await SettingsDialogs().deleteIndexer(context);
            if (result) {
              showHarbrSuccessSnackBar(
                title: 'search.IndexerDeleted'.tr(),
                message: _indexer!.displayName,
              );
              _indexer!.delete();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.indexers.listenableBuilder(
      selectKeys: [widget.id],
      builder: (context, _) {
        if (!HarbrBox.indexers.contains(widget.id)) return Container();
        _indexer = HarbrBox.indexers.read(widget.id);
        return HarbrListView(
          controller: scrollController,
          children: [
            _displayName(),
            _apiURL(),
            _apiKey(),
            _headers(),
          ],
        );
      },
    );
  }

  Widget _displayName() {
    String _name = _indexer!.displayName;
    return HarbrBlock(
      title: 'settings.DisplayName'.tr(),
      body: [TextSpan(text: _name.isEmpty ? 'harbr.NotSet'.tr() : _name)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values = await HarbrDialogs().editText(
          context,
          'settings.DisplayName'.tr(),
          prefill: _indexer!.displayName,
        );
        if (values.item1) {
          _indexer!.displayName = values.item2;
        }
        _indexer!.save();
      },
    );
  }

  Widget _apiURL() {
    String _host = _indexer!.host;
    return HarbrBlock(
      title: 'search.IndexerAPIHost'.tr(),
      body: [TextSpan(text: _host.isEmpty ? 'harbr.NotSet'.tr() : _host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values = await HarbrDialogs().editText(
          context,
          'search.IndexerAPIHost'.tr(),
          prefill: _host,
        );
        if (values.item1 && mounted) {
          _indexer!.host = values.item2;
        }
        _indexer!.save();
      },
    );
  }

  Widget _apiKey() {
    String _key = _indexer!.apiKey;
    return HarbrBlock(
      title: 'search.IndexerAPIKey'.tr(),
      body: [TextSpan(text: _key.isEmpty ? 'harbr.NotSet'.tr() : _key)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values = await HarbrDialogs().editText(
          context,
          'search.IndexerAPIKey'.tr(),
          prefill: _key,
        );
        if (values.item1) {
          _indexer!.apiKey = values.item2;
        }
        _indexer!.save();
      },
    );
  }

  Widget _headers() {
    return HarbrBlock(
      title: 'settings.CustomHeaders'.tr(),
      body: [TextSpan(text: 'settings.CustomHeadersDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: () => SettingsRoutes.CONFIGURATION_SEARCH_EDIT_INDEXER_HEADERS.go(
        params: {
          'id': widget.id.toString(),
        },
      ),
    );
  }
}
