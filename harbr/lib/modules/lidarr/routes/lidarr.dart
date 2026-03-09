import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/routes/lidarr.dart';

class LidarrRoute extends StatefulWidget {
  const LidarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<LidarrRoute> createState() => _State();
}

class _State extends State<LidarrRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;
  String _profileState = HarbrProfile.current.toString();
  LidarrAPI _api = LidarrAPI.from(HarbrProfile.current);

  final List _refreshKeys = [
    GlobalKey<RefreshIndicatorState>(),
    GlobalKey<RefreshIndicatorState>(),
    GlobalKey<RefreshIndicatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController =
        HarbrPageController(initialPage: LidarrDatabase.NAVIGATION_INDEX.read());
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      body: _body(),
      drawer: _drawer(),
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar: _bottomNavigationBar(),
      onProfileChange: (_) {
        if (_profileState != HarbrProfile.current.toString()) _refreshProfile();
      },
    );
  }

  Widget _drawer() => HarbrDrawer(page: HarbrModule.LIDARR.key);

  Widget? _bottomNavigationBar() {
    if (HarbrProfile.current.lidarrEnabled)
      return LidarrNavigationBar(pageController: _pageController);
    return null;
  }

  Widget _body() {
    if (!HarbrProfile.current.lidarrEnabled)
      return HarbrMessage.moduleNotEnabled(
        context: context,
        module: HarbrModule.LIDARR.title,
      );
    return HarbrPageView(
      controller: _pageController,
      children: [
        LidarrCatalogue(
          refreshIndicatorKey: _refreshKeys[0],
          refreshAllPages: _refreshAllPages,
        ),
        LidarrMissing(
          refreshIndicatorKey: _refreshKeys[1],
          refreshAllPages: _refreshAllPages,
        ),
        LidarrHistory(
          refreshIndicatorKey: _refreshKeys[2],
          refreshAllPages: _refreshAllPages,
        ),
      ],
    );
  }

  Widget _appBar() {
    const db = HarbrBox.profiles;
    final profiles = db.keys.fold<List<String>>([], (arr, key) {
      if (HarbrBox.profiles.read(key)?.lidarrEnabled ?? false) arr.add(key);
      return arr;
    });
    List<Widget>? actions;
    if (HarbrProfile.current.lidarrEnabled)
      actions = [
        HarbrIconButton(
          icon: Icons.add_rounded,
          onPressed: () async => _enterAddArtist(),
        ),
        HarbrIconButton(
          icon: Icons.more_vert_rounded,
          onPressed: () async => _handlePopup(),
        ),
      ];
    return HarbrAppBar.dropdown(
      title: HarbrModule.LIDARR.title,
      useDrawer: true,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: LidarrNavigationBar.scrollControllers,
    );
  }

  Future<void> _enterAddArtist() async {
    final _model = Provider.of<LidarrState>(context, listen: false);
    _model.addSearchQuery = '';
    LidarrRoutes.ADD_ARTIST.go();
  }

  Future<void> _handlePopup() async {
    List<dynamic> values = await LidarrDialogs.globalSettings(context);
    if (values[0])
      switch (values[1]) {
        case 'web_gui':
          HarbrProfile profile = HarbrProfile.current;
          await profile.lidarrHost.openLink();
          break;
        case 'update_library':
          await _api
              .updateLibrary()
              .then((_) => showHarbrSuccessSnackBar(
                  title: 'Updating Library...',
                  message: 'Updating your library in the background'))
              .catchError((error) => showHarbrErrorSnackBar(
                  title: 'Failed to Update Library', error: error));
          break;
        case 'rss_sync':
          await _api
              .triggerRssSync()
              .then((_) => showHarbrSuccessSnackBar(
                  title: 'Running RSS Sync...',
                  message: 'Running RSS sync in the background'))
              .catchError((error) => showHarbrErrorSnackBar(
                  title: 'Failed to Run RSS Sync', error: error));
          break;
        case 'backup':
          await _api
              .triggerBackup()
              .then((_) => showHarbrSuccessSnackBar(
                  title: 'Backing Up Database...',
                  message: 'Backing up database in the background'))
              .catchError((error) => showHarbrErrorSnackBar(
                  title: 'Failed to Backup Database', error: error));
          break;
        case 'missing_search':
          {
            List<dynamic> values =
                await LidarrDialogs.searchAllMissing(context);
            if (values[0])
              await _api
                  .searchAllMissing()
                  .then((_) => showHarbrSuccessSnackBar(
                      title: 'Searching...',
                      message: 'Search for all missing albums'))
                  .catchError((error) => showHarbrErrorSnackBar(
                      title: 'Failed to Search', error: error));
            break;
          }
        default:
          HarbrLogger().warning('Unknown Case: ${values[1]}');
      }
  }

  void _refreshProfile() {
    _api = LidarrAPI.from(HarbrProfile.current);
    _profileState = HarbrProfile.current.toString();
    _refreshAllPages();
  }

  void _refreshAllPages() {
    for (var key in _refreshKeys) key?.currentState?.show();
  }
}
