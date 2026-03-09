import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/tables/sabnzbd.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/sabnzbd.dart';
import 'package:harbr/router/routes/sabnzbd.dart';
import 'package:harbr/system/filesystem/file.dart';
import 'package:harbr/system/filesystem/filesystem.dart';

class SABnzbdRoute extends StatefulWidget {
  final bool showDrawer;

  const SABnzbdRoute({
    Key? key,
    this.showDrawer = true,
  }) : super(key: key);

  @override
  State<SABnzbdRoute> createState() => _State();
}

class _State extends State<SABnzbdRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;
  String _profileState = HarbrProfile.current.toString();
  SABnzbdAPI _api = SABnzbdAPI.from(HarbrProfile.current);

  final List _refreshKeys = [
    GlobalKey<RefreshIndicatorState>(),
    GlobalKey<RefreshIndicatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
        initialPage: SABnzbdDatabase.NAVIGATION_INDEX.read());
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      body: _body(),
      drawer: widget.showDrawer ? _drawer() : null,
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar: _bottomNavigationBar(),
      extendBodyBehindAppBar: false,
      extendBody: false,
      onProfileChange: (_) {
        if (_profileState != HarbrProfile.current.toString()) _refreshProfile();
      },
    );
  }

  Widget _drawer() => HarbrDrawer(page: HarbrModule.SABNZBD.key);

  Widget? _bottomNavigationBar() {
    if (HarbrProfile.current.sabnzbdEnabled)
      return SABnzbdNavigationBar(pageController: _pageController);
    return null;
  }

  Widget _appBar() {
    List<String> profiles = HarbrBox.profiles.keys.fold([], (value, element) {
      if (HarbrBox.profiles.read(element)?.sabnzbdEnabled ?? false)
        value.add(element);
      return value;
    });
    List<Widget>? actions;
    if (HarbrProfile.current.sabnzbdEnabled)
      actions = [
        Selector<SABnzbdState, bool>(
          selector: (_, model) => model.error,
          builder: (context, error, widget) =>
              error ? Container() : const SABnzbdAppBarStats(),
        ),
        HarbrIconButton(
          icon: Icons.more_vert_rounded,
          onPressed: () async => _handlePopup(),
        ),
      ];
    return HarbrAppBar.dropdown(
      title: HarbrModule.SABNZBD.title,
      useDrawer: widget.showDrawer,
      hideLeading: !widget.showDrawer,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: SABnzbdNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    if (!HarbrProfile.current.sabnzbdEnabled)
      return HarbrMessage.moduleNotEnabled(
        context: context,
        module: HarbrModule.SABNZBD.title,
      );
    return HarbrPageView(
      controller: _pageController,
      children: [
        SABnzbdQueue(
          refreshIndicatorKey: _refreshKeys[0],
        ),
        SABnzbdHistory(
          refreshIndicatorKey: _refreshKeys[1],
        ),
      ],
    );
  }

  Future<void> _handlePopup() async {
    List<dynamic> values = await SABnzbdDialogs.globalSettings(context);
    if (values[0])
      switch (values[1]) {
        case 'web_gui':
          HarbrProfile profile = HarbrProfile.current;
          await profile.sabnzbdHost.openLink();
          break;
        case 'add_nzb':
          _addNZB();
          break;
        case 'sort':
          _sort();
          break;
        case 'clear_history':
          _clearHistory();
          break;
        case 'complete_action':
          _completeAction();
          break;
        case 'server_details':
          _serverDetails();
          break;
        default:
          HarbrLogger().warning('Unknown Case: ${values[1]}');
      }
  }

  Future<void> _serverDetails() async => SABnzbdRoutes.STATISTICS.go();

  Future<void> _completeAction() async {
    List values = await SABnzbdDialogs.changeOnCompleteAction(context);
    if (values[0])
      SABnzbdAPI.from(HarbrProfile.current)
          .setOnCompleteAction(values[1])
          .then((_) => showHarbrSuccessSnackBar(
                title: 'On Complete Action Set',
                message: values[2],
              ))
          .catchError((error) => showHarbrErrorSnackBar(
                title: 'Failed to Set Complete Action',
                error: error,
              ));
  }

  Future<void> _clearHistory() async {
    List values = await SABnzbdDialogs.clearAllHistory(context);
    if (values[0])
      SABnzbdAPI.from(HarbrProfile.current)
          .clearHistory(values[1], values[2])
          .then((_) {
        showHarbrSuccessSnackBar(
          title: 'History Cleared',
          message: values[3],
        );
        _refreshAllPages();
      }).catchError((error) {
        showHarbrErrorSnackBar(
          title: 'Failed to Upload NZB',
          error: error,
        );
      });
  }

  Future<void> _sort() async {
    List values = await SABnzbdDialogs.sortQueue(context);
    if (values[0])
      await SABnzbdAPI.from(HarbrProfile.current)
          .sortQueue(values[1], values[2])
          .then((_) {
        showHarbrSuccessSnackBar(
          title: 'Sorted Queue',
          message: values[3],
        );
        (_refreshKeys[0] as GlobalKey<RefreshIndicatorState>)
            .currentState
            ?.show();
      }).catchError((error) {
        showHarbrErrorSnackBar(
          title: 'Failed to Sort Queue',
          error: error,
        );
      });
  }

  Future<void> _addNZB() async {
    List values = await SABnzbdDialogs.addNZB(context);
    if (values[0])
      switch (values[1]) {
        case 'link':
          _addByURL();
          break;
        case 'file':
          _addByFile();
          break;
        default:
          HarbrLogger().warning('Unknown Case: ${values[1]}');
      }
  }

  Future<void> _addByFile() async {
    try {
      HarbrFile? _file = await HarbrFileSystem().read(context, [
        'nzb',
        'zip',
        'rar',
        'gz',
      ]);
      if (_file != null) {
        if (_file.data.isNotEmpty) {
          await _api.uploadFile(_file.data, _file.name).then((value) {
            _refreshKeys[0]?.currentState?.show();
            showHarbrSuccessSnackBar(
              title: 'Uploaded NZB (File)',
              message: _file.name,
            );
          });
        } else {
          showHarbrErrorSnackBar(
            title: 'Failed to Upload NZB',
            message: 'Please select a valid file type',
          );
        }
      }
    } catch (error, stack) {
      HarbrLogger().error('Failed to add NZB by file', error, stack);
      showHarbrErrorSnackBar(
        title: 'Failed to Upload NZB',
        error: error,
      );
    }
  }

  Future<void> _addByURL() async {
    List values = await SABnzbdDialogs.addNZBUrl(context);
    if (values[0])
      await _api
          .uploadURL(values[1])
          .then((_) => showHarbrSuccessSnackBar(
                title: 'Uploaded NZB (URL)',
                message: values[1],
              ))
          .catchError((error) => showHarbrErrorSnackBar(
                title: 'Failed to Upload NZB',
                error: error,
              ));
  }

  void _refreshProfile() {
    _api = SABnzbdAPI.from(HarbrProfile.current);
    _profileState = HarbrProfile.current.toString();
    _refreshAllPages();
  }

  void _refreshAllPages() {
    for (var key in _refreshKeys) key?.currentState?.show();
  }
}
