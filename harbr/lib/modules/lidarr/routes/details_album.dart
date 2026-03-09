import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/routes/lidarr.dart';

class ArtistAlbumDetailsRoute extends StatefulWidget {
  final int artistId;
  final int albumId;
  final bool monitored;

  const ArtistAlbumDetailsRoute({
    Key? key,
    required this.artistId,
    required this.albumId,
    required this.monitored,
  }) : super(key: key);

  @override
  State<ArtistAlbumDetailsRoute> createState() => _State();
}

class _State extends State<ArtistAlbumDetailsRoute>
    with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<List<LidarrTrackData>>? _future;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refresh();
    });
  }

  Future<void> _refresh() async {
    final api = LidarrAPI.from(HarbrProfile.current);
    setState(() {
      _future = api.getAlbumTracks(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      body: _body,
      appBar: _appBar,
    );
  }

  PreferredSizeWidget get _appBar {
    return HarbrAppBar(
      title: 'Album Details',
      scrollControllers: [scrollController],
      actions: <Widget>[
        HarbrIconButton(
          icon: Icons.search_rounded,
          onPressed: () async => _automaticSearch(),
          onLongPress: () async => _manualSearch(),
        ),
      ],
    );
  }

  Widget get _body {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: _refresh,
      child: FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<List<LidarrTrackData>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                if (snapshot.hasError || snapshot.data == null) {
                  return HarbrMessage.error(onTap: _refresh);
                }
                return _list(snapshot.data!);
              }
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
              return const HarbrLoader();
          }
        },
      ),
    );
  }

  Widget _list(List<LidarrTrackData> results) {
    if (results.isEmpty) {
      return HarbrMessage(
        text: 'No Tracks Found',
        buttonText: 'Refresh',
        onTap: _refresh,
      );
    }

    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return LidarrDetailsTrackTile(
          data: results[index],
          monitored: widget.monitored,
        );
      },
    );
  }

  Future<void> _automaticSearch() async {
    LidarrAPI _api = LidarrAPI.from(HarbrProfile.current);
    _api.searchAlbums([widget.albumId]).then((_) {
      showHarbrSuccessSnackBar(
        title: 'Searching...',
        message: '',
      );
    }).catchError((error, stack) {
      HarbrLogger().error('Failed to search for album', error, stack);
      showHarbrErrorSnackBar(
        title: 'Failed to Search',
        error: error,
      );
    });
  }

  Future<void> _manualSearch() async {
    LidarrRoutes.ARTIST_ALBUM_RELEASES.go(params: {
      'artist': widget.artistId.toString(),
      'album': widget.albumId.toString(),
    });
  }
}
