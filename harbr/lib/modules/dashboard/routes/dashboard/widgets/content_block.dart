import 'package:flutter/material.dart';

import 'package:harbr/database/models/profile.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/dashboard/core/api/data/abstract.dart';
import 'package:harbr/modules/dashboard/core/api/data/lidarr.dart';
import 'package:harbr/modules/dashboard/core/api/data/radarr.dart';
import 'package:harbr/modules/dashboard/core/api/data/sonarr.dart';

class ContentBlock extends StatelessWidget {
  final CalendarData data;
  const ContentBlock(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headers = getHeaders();
    return HarbrBlock(
      title: data.title,
      body: data.body,
      posterHeaders: headers,
      backgroundHeaders: headers,
      posterUrl: data.posterUrl(context),
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      backgroundUrl: data.backgroundUrl(context),
      trailing: data.trailing(context),
      onTap: () async => data.enterContent(context),
    );
  }

  Map getHeaders() {
    switch (data.runtimeType) {
      case CalendarLidarrData:
        return HarbrProfile.current.lidarrHeaders;
      case CalendarRadarrData:
        return HarbrProfile.current.radarrHeaders;
      case CalendarSonarrData:
        return HarbrProfile.current.sonarrHeaders;
      default:
        return const {};
    }
  }
}
