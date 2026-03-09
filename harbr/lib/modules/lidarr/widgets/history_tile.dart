import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/routes/lidarr.dart';

class LidarrHistoryTile extends StatefulWidget {
  static final double extent = HarbrBlock.calculateItemExtent(2);
  final LidarrHistoryData entry;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function refresh;

  const LidarrHistoryTile({
    Key? key,
    required this.entry,
    required this.scaffoldKey,
    required this.refresh,
  }) : super(key: key);

  @override
  State<LidarrHistoryTile> createState() => _State();
}

class _State extends State<LidarrHistoryTile> {
  @override
  Widget build(BuildContext context) => HarbrBlock(
        title: widget.entry.title,
        body: widget.entry.subtitle,
        trailing: const HarbrIconButton.arrow(),
        onTap: () async => _enterArtist(),
      );

  Future<void> _enterArtist() async {
    if (widget.entry.artistID == -1) {
      showHarbrInfoSnackBar(
        title: 'No Artist Available',
        message: 'There is no artist associated with this history entry',
      );
    } else {
      LidarrRoutes.ARTIST.go(
        params: {
          'artist': widget.entry.artistID.toString(),
        },
      );
    }
  }
}
