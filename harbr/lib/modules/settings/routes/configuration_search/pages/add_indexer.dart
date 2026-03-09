import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationSearchAddIndexerRoute extends StatefulWidget {
  const ConfigurationSearchAddIndexerRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationSearchAddIndexerRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchAddIndexerRoute>
    with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _indexer = HarbrIndexer();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'search.AddIndexer'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'search.AddIndexer'.tr(),
          icon: Icons.add_rounded,
          onTap: () async {
            if (_indexer.displayName.isEmpty ||
                _indexer.host.isEmpty ||
                _indexer.apiKey.isEmpty) {
              showHarbrErrorSnackBar(
                title: 'search.FailedToAddIndexer'.tr(),
                message: 'settings.AllFieldsAreRequired'.tr(),
              );
            } else {
              HarbrBox.indexers.create(_indexer);
              showHarbrSuccessSnackBar(
                title: 'search.IndexerAdded'.tr(),
                message: _indexer.displayName,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _displayName(),
        _apiURL(),
        _apiKey(),
        _headers(),
      ],
    );
  }

  Widget _displayName() {
    String _name = _indexer.displayName;
    return HarbrBlock(
      title: 'settings.DisplayName'.tr(),
      body: [TextSpan(text: _name.isEmpty ? 'harbr.NotSet'.tr() : _name)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values = await HarbrDialogs().editText(
          context,
          'settings.DisplayName'.tr(),
          prefill: _name,
        );
        if (values.item1 && mounted) {
          setState(() => _indexer.displayName = values.item2);
        }
      },
    );
  }

  Widget _apiURL() {
    String _host = _indexer.host;
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
          setState(() => _indexer.host = values.item2);
        }
      },
    );
  }

  Widget _apiKey() {
    String _key = _indexer.apiKey;
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
        if (values.item1 && mounted) {
          setState(() => _indexer.apiKey = values.item2);
        }
      },
    );
  }

  Widget _headers() {
    return HarbrBlock(
      title: 'settings.CustomHeaders'.tr(),
      body: [TextSpan(text: 'settings.CustomHeadersDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: () => SettingsRoutes.CONFIGURATION_SEARCH_ADD_INDEXER_HEADERS.go(
        extra: _indexer,
      ),
    );
  }
}
