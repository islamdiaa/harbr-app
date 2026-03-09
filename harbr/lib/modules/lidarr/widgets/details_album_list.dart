import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';

class LidarrDetailsAlbumList extends StatefulWidget {
  final int artistID;

  const LidarrDetailsAlbumList({
    Key? key,
    required this.artistID,
  }) : super(key: key);

  @override
  State<LidarrDetailsAlbumList> createState() => _State();
}

class _State extends State<LidarrDetailsAlbumList>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<LidarrAlbumData>>? _future;
  List<LidarrAlbumData>? _results;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    _results = [];
    LidarrAPI _api = LidarrAPI.from(HarbrProfile.current);
    setState(() {
      _future = _api.getArtistAlbums(widget.artistID);
    });
  }

  void _refreshState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body;
  }

  Widget get _body => HarbrRefreshIndicator(
        context: context,
        key: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<LidarrAlbumData>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  if (snapshot.hasError || snapshot.data == null) {
                    return HarbrMessage.error(onTap: _refresh);
                  }
                  _results = snapshot.data;
                  return _list;
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

  Widget get _list => Consumer<LidarrState>(
        builder: (context, model, _) {
          return HarbrListViewBuilder(
            controller: LidarrArtistNavigationBar.scrollControllers[1],
            itemCount: _results!.isEmpty ? 1 : _results!.length,
            itemBuilder: _results!.isEmpty
                ? (context, _) => const HarbrMessage(text: 'No Albums Found')
                : (context, index) => LidarrDetailsAlbumTile(
                      data: _results![index],
                      artistId: widget.artistID,
                      refreshState: _refreshState,
                    ),
          );
        },
      );
}
