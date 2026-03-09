import 'package:flutter/material.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/lidarr/core/api.dart';
import 'package:harbr/utils/links.dart';
import 'package:harbr/widgets/ui.dart';

class LinksSheet extends HarbrBottomModalSheet {
  LidarrCatalogueData artist;

  LinksSheet({
    required this.artist,
  });

  @override
  Widget builder(BuildContext context) {
    return HarbrListViewModal(
      children: [
        if (artist.bandsintownURI?.isNotEmpty ?? false)
          HarbrBlock(
            title: 'Bandsintown',
            leading: const HarbrIconButton(
              icon: HarbrIcons.BANDSINTOWN,
              iconSize: HarbrUI.ICON_SIZE - 4.0,
            ),
            onTap: artist.bandsintownURI!.openLink,
          ),
        if (artist.discogsURI?.isNotEmpty ?? false)
          HarbrBlock(
            title: 'Discogs',
            leading: const HarbrIconButton(
              icon: HarbrIcons.DISCOGS,
              iconSize: HarbrUI.ICON_SIZE - 2.0,
            ),
            onTap: artist.discogsURI!.openLink,
          ),
        if (artist.lastfmURI?.isNotEmpty ?? false)
          HarbrBlock(
            title: 'Last.fm',
            leading: const HarbrIconButton(icon: HarbrIcons.LASTFM),
            onTap: artist.lastfmURI!.openLink,
          ),
        HarbrBlock(
          title: 'MusicBrainz',
          leading: const HarbrIconButton(icon: HarbrIcons.MUSICBRAINZ),
          onTap:
              HarbrLinkedContent.musicBrainz(artist.foreignArtistID)!.openLink,
        ),
      ],
    );
  }
}
