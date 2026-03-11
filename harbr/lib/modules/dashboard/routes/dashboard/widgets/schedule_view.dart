import 'package:flutter/material.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/vendor.dart';

import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/dashboard/core/api/data/abstract.dart';
import 'package:harbr/modules/dashboard/core/api/data/lidarr.dart';
import 'package:harbr/modules/dashboard/core/api/data/radarr.dart';
import 'package:harbr/modules/dashboard/core/api/data/sonarr.dart';
import 'package:harbr/modules/dashboard/core/state.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class ScheduleView extends StatefulWidget {
  final Map<DateTime, List<CalendarData>> events;
  final String? searchQuery;

  const ScheduleView({
    Key? key,
    required this.events,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<ScheduleView> createState() => _State();
}

class _State extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    final controller = HomeNavigationBar.scrollControllers[1];

    if (widget.events.isEmpty) {
      return HarbrListView(
        controller: controller,
        children: [
          HarbrMessage.inList(text: 'dashboard.NoNewContent'.tr()),
        ],
      );
    }

    final schedule = _buildSchedule();
    Future.microtask(() => controller.animateToOffset(schedule.item2));

    return HarbrCustomScrollView(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            vertical: HarbrTokens.sm,
            horizontal: HarbrTokens.md,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(schedule.item1),
          ),
        ),
      ],
    );
  }

  Tuple2<List<Widget>, double> _buildSchedule() {
    double offset = 0.0;
    double offsetOfSelected = 0.0;

    List<Widget> days = [];
    List<DateTime> keys = widget.events.keys.toList();
    keys.sort();

    final today = context.read<DashboardState>().today;

    for (final key in keys) {
      final selected = context.read<DashboardState>().selected;
      if (key.isBefore(selected) || key.isAtSameMomentAs(selected)) {
        offsetOfSelected = offset;
      }

      final events = widget.events[key] ?? [];
      final isToday = key.isAtSameMomentAs(today);

      // Filter events by search query if provided
      final filteredEvents = _filterEvents(events);

      final built = _buildDay(key, filteredEvents, isToday);
      offset += built.item2;
      days.add(built.item1);
    }

    return Tuple2(days, offsetOfSelected);
  }

  List<CalendarData> _filterEvents(List<CalendarData> events) {
    final query = widget.searchQuery?.trim().toLowerCase();
    if (query == null || query.isEmpty) return events;
    return events.where((e) => e.title.toLowerCase().contains(query)).toList();
  }

  Tuple2<Widget, double> _buildDay(
    DateTime day,
    List<CalendarData> events,
    bool isToday,
  ) {
    final hasEvents = events.isNotEmpty;

    final Widget content;
    final double estimatedHeight;

    if (hasEvents) {
      // Each card is approximately 120px tall + spacing
      estimatedHeight = events.length * 136.0 + HarbrTokens.sm;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: events
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: HarbrTokens.sm),
                  child: _TimelineMediaCard(data: e),
                ))
            .toList(),
      );
    } else {
      estimatedHeight = 56.0;
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: HarbrTokens.lg),
        child: Text(
          'No releases today',
          style: TextStyle(
            color: context.harbr.onSurfaceFaint,
            fontSize: HarbrUI.FONT_SIZE_H3,
          ),
        ),
      );
    }

    final widget = Padding(
      padding: const EdgeInsets.only(bottom: HarbrTokens.md),
      child: HarbrTimelineIndicator(
        date: day,
        isToday: isToday,
        child: content,
      ),
    );

    return Tuple2(widget, estimatedHeight);
  }
}

/// A media card designed for the timeline schedule view.
///
/// Displays a poster on the left with status badges, title, time,
/// detail rows, and action buttons on the right.
class _TimelineMediaCard extends StatelessWidget {
  final CalendarData data;

  const _TimelineMediaCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final headers = _getHeaders();

    return GestureDetector(
      onTap: () => data.enterContent(context),
      child: Container(
        padding: const EdgeInsets.all(HarbrTokens.lg),
        decoration: BoxDecoration(
          color: harbr.surface0,
          borderRadius: HarbrTokens.borderRadius12,
          border: Border.all(color: harbr.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            HarbrPoster(
              url: data.posterUrl(context),
              headers: headers,
              placeholderIcon: HarbrIcons.VIDEO_CAM,
              size: PosterSize.xl,
              borderRadius: HarbrTokens.borderRadiusMd,
            ),
            const SizedBox(width: HarbrTokens.lg),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status badges
                  _buildStatusBadges(context),
                  const SizedBox(height: HarbrTokens.xs),
                  // Title
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: harbr.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Time
                  Text(
                    _getTimeString(),
                    style: TextStyle(
                      color: harbr.onSurfaceDim,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: HarbrTokens.sm),
                  // Detail rows
                  ..._buildDetailRows(context),
                  // Action buttons for missing/upcoming items
                  if (_showActionButtons()) ...[
                    const SizedBox(height: HarbrTokens.sm),
                    _buildActionButtons(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map _getHeaders() {
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

  Widget _buildStatusBadges(BuildContext context) {
    final badges = <Widget>[];

    if (data is CalendarSonarrData) {
      final sonarr = data as CalendarSonarrData;
      if (sonarr.hasFile) {
        badges.add(HarbrStatusBadge(
          type: StatusType.downloaded,
          label: sonarr.fileQualityProfile ?? 'Downloaded',
        ));
      } else if (sonarr.hasAired) {
        badges.add(const HarbrStatusBadge(type: StatusType.missing));
      } else {
        badges.add(const HarbrStatusBadge(type: StatusType.upcoming));
      }
    } else if (data is CalendarRadarrData) {
      final radarr = data as CalendarRadarrData;
      if (radarr.hasFile) {
        badges.add(HarbrStatusBadge(
          type: StatusType.downloaded,
          label: radarr.fileQualityProfile ?? 'Downloaded',
        ));
      } else if (radarr.hasReleased) {
        badges.add(const HarbrStatusBadge(type: StatusType.missing));
      } else {
        badges.add(const HarbrStatusBadge(type: StatusType.upcoming));
      }
    } else if (data is CalendarLidarrData) {
      final lidarr = data as CalendarLidarrData;
      if (lidarr.hasAllFiles) {
        badges.add(const HarbrStatusBadge(type: StatusType.downloaded));
      } else {
        badges.add(const HarbrStatusBadge(type: StatusType.missing));
      }
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: HarbrTokens.xs,
      runSpacing: HarbrTokens.xs,
      children: badges,
    );
  }

  String _getTimeString() {
    if (data is CalendarSonarrData) {
      return (data as CalendarSonarrData).airTimeString;
    }
    return '00:00';
  }

  List<Widget> _buildDetailRows(BuildContext context) {
    final harbr = context.harbr;
    final rows = <Widget>[];

    if (data is CalendarSonarrData) {
      final sonarr = data as CalendarSonarrData;
      rows.add(_DetailRow(
        icon: Icons.tv_rounded,
        text:
            'S${sonarr.seasonNumber.toString().padLeft(2, '0')}E${sonarr.episodeNumber.toString().padLeft(2, '0')}',
        harbr: harbr,
      ));
      rows.add(_DetailRow(
        icon: Icons.text_snippet_rounded,
        text: sonarr.episodeTitle,
        harbr: harbr,
      ));
    } else if (data is CalendarRadarrData) {
      final radarr = data as CalendarRadarrData;
      rows.add(_DetailRow(
        icon: Icons.movie_rounded,
        text: 'Digital release',
        harbr: harbr,
      ));
      if (radarr.studio.isNotEmpty) {
        rows.add(_DetailRow(
          icon: Icons.business_rounded,
          text: radarr.studio,
          harbr: harbr,
        ));
      }
    } else if (data is CalendarLidarrData) {
      final lidarr = data as CalendarLidarrData;
      rows.add(_DetailRow(
        icon: Icons.album_rounded,
        text: lidarr.albumTitle,
        harbr: harbr,
      ));
      rows.add(_DetailRow(
        icon: Icons.music_note_rounded,
        text: lidarr.totalTrackCount == 1
            ? '1 Track'
            : '${lidarr.totalTrackCount} Tracks',
        harbr: harbr,
      ));
    }

    return rows;
  }

  bool _showActionButtons() {
    if (data is CalendarSonarrData) {
      return !(data as CalendarSonarrData).hasFile;
    }
    if (data is CalendarRadarrData) {
      return !(data as CalendarRadarrData).hasFile;
    }
    if (data is CalendarLidarrData) {
      return !(data as CalendarLidarrData).hasAllFiles;
    }
    return false;
  }

  Widget _buildActionButtons(BuildContext context) {
    final harbr = context.harbr;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search action
        _ActionCircle(
          icon: Icons.search_rounded,
          harbr: harbr,
          onTap: () => data.trailingOnPress(context),
        ),
        const SizedBox(width: HarbrTokens.sm),
        // Navigate / details action
        _ActionCircle(
          icon: Icons.open_in_new_rounded,
          harbr: harbr,
          onTap: () => data.enterContent(context),
        ),
      ],
    );
  }
}

/// A single icon + text detail row used inside timeline media cards.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final HarbrThemeData harbr;

  const _DetailRow({
    required this.icon,
    required this.text,
    required this.harbr,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(
            icon,
            size: HarbrTokens.iconSm,
            color: harbr.onSurfaceFaint,
          ),
          const SizedBox(width: HarbrTokens.xs),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A circular action button used in timeline media cards for
/// missing/upcoming items.
class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final HarbrThemeData harbr;
  final VoidCallback? onTap;

  const _ActionCircle({
    required this.icon,
    required this.harbr,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: harbr.surface1,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(HarbrTokens.sm),
          child: Icon(
            icon,
            color: harbr.onSurfaceDim,
            size: HarbrTokens.iconMd,
          ),
        ),
      ),
    );
  }
}
