import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';

class LidarrDetailsOverview extends StatefulWidget {
  final LidarrCatalogueData data;

  const LidarrDetailsOverview({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<LidarrDetailsOverview> createState() => _State();
}

class _State extends State<LidarrDetailsOverview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrListView(
      controller: LidarrArtistNavigationBar.scrollControllers[0],
      children: <Widget>[
        LidarrDescriptionBlock(
          title: widget.data.title,
          description: widget.data.overview == ''
              ? 'No Summary Available'
              : widget.data.overview,
          uri: widget.data.posterURI(),
          squareImage: true,
          headers: HarbrProfile.current.lidarrHeaders,
        ),
        HarbrTableCard(
          content: [
            HarbrTableContent(
              title: 'Path',
              body: widget.data.path,
            ),
            HarbrTableContent(
              title: 'Quality',
              body: widget.data.quality,
            ),
            HarbrTableContent(
              title: 'Metadata',
              body: widget.data.metadata,
            ),
            HarbrTableContent(
              title: 'Albums',
              body: widget.data.albums,
            ),
            HarbrTableContent(
              title: 'Tracks',
              body: widget.data.tracks,
            ),
            HarbrTableContent(
              title: 'Genres',
              body: widget.data.genre,
            ),
          ],
        ),
      ],
    );
  }
}
