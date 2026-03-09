import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';

class AddArtistRoute extends StatefulWidget {
  const AddArtistRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<AddArtistRoute> createState() => _State();
}

class _State extends State<AddArtistRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Future<List<LidarrSearchData>>? _future;
  List<String> _availableIDs = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableArtists();
  }

  @override
  Widget build(BuildContext context) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        body: _body(),
        appBar: _appBar() as PreferredSizeWidget?,
      );

  Future<void> _refresh() async {
    final _model = Provider.of<LidarrState>(context, listen: false);
    final _api = LidarrAPI.from(HarbrProfile.current);
    setState(() {
      _future = _api.searchArtists(_model.addSearchQuery);
    });
  }

  Future<void> _fetchAvailableArtists() async {
    await LidarrAPI.from(HarbrProfile.current)
        .getAllArtistIDs()
        .then((data) => _availableIDs = data)
        .catchError((error) => _availableIDs = []);
  }

  Widget _appBar() {
    return HarbrAppBar(
      scrollControllers: [scrollController],
      title: 'Add Artist',
      bottom: LidarrAddSearchBar(
        callback: _refresh,
        scrollController: scrollController,
      ),
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: _refresh,
      child: FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<List<LidarrSearchData>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.none)
            return Container();
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to fetch Lidarr artist lookup',
                snapshot.error,
                snapshot.stackTrace,
              );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) return _list(snapshot.data);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(List<LidarrSearchData>? data) {
    if ((data?.length ?? 0) == 0)
      return HarbrListView(
        controller: scrollController,
        children: const [HarbrMessage(text: 'No Results Found')],
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: data!.length,
      itemBuilder: (context, index) => LidarrAddSearchResultTile(
        data: data[index],
        alreadyAdded: _availableIDs.contains(data[index].foreignArtistId),
      ),
    );
  }
}
