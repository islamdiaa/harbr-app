import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/routes/lidarr.dart';

class LidarrMissingTile extends StatefulWidget {
  static final double extent = HarbrBlock.calculateItemExtent(2);

  final LidarrMissingData entry;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function refresh;

  const LidarrMissingTile({
    Key? key,
    required this.entry,
    required this.scaffoldKey,
    required this.refresh,
  }) : super(key: key);

  @override
  State<LidarrMissingTile> createState() => _State();
}

class _State extends State<LidarrMissingTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: widget.entry.artistTitle,
      body: [
        TextSpan(
          text: widget.entry.title,
          style: const TextStyle(
            color: HarbrColours.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
        TextSpan(
          text: 'Released ${widget.entry.releaseDateString}',
          style: const TextStyle(
            color: HarbrColours.red,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      ],
      trailing: HarbrIconButton(
        icon: HarbrIcons.SEARCH,
        onPressed: () async => _search(),
        onLongPress: () async => _interactiveSearch(),
      ),
      onTap: () async => _enterAlbum(),
      onLongPress: () async => _enterArtist(),
      posterUrl: widget.entry.albumCoverURI(),
      posterHeaders: HarbrProfile.current.lidarrHeaders,
      posterIsSquare: true,
      posterPlaceholderIcon: HarbrIcons.MUSIC,
      backgroundUrl: widget.entry.fanartURI(),
      backgroundHeaders: HarbrProfile.current.lidarrHeaders,
    );
  }

  Future<void> _search() async {
    final _api = LidarrAPI.from(HarbrProfile.current);
    await _api
        .searchAlbums([widget.entry.albumID])
        .then((_) => showHarbrSuccessSnackBar(
            title: 'Searching...', message: widget.entry.title))
        .catchError((error) =>
            showHarbrErrorSnackBar(title: 'Failed to Search', error: error));
  }

  Future<void> _interactiveSearch() async {
    LidarrRoutes.ARTIST_ALBUM_RELEASES.go(params: {
      'artist': widget.entry.artistID.toString(),
      'album': widget.entry.albumID.toString(),
    });
  }

  Future<void> _enterArtist() async {
    LidarrRoutes.ARTIST.go(
      params: {
        'artist': widget.entry.artistID.toString(),
      },
    );
  }

  Future<void> _enterAlbum() async {
    LidarrRoutes.ARTIST_ALBUM.go(params: {
      'album': widget.entry.albumID.toString(),
      'artist': widget.entry.artistID.toString(),
    }, queryParams: {
      'monitored': widget.entry.monitored.toString(),
    });
  }
}
