import 'package:flutter/material.dart';

import 'package:harbr/database/models/profile.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/filter_action_bar.dart';
import 'package:harbr/widgets/ui/search_field.dart';
import 'package:harbr/widgets/ui/empty_state.dart';
import 'package:harbr/widgets/ui/progress_bar.dart';

/// Unified queue/activities page aggregating download activity from all
/// enabled *arr services.
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage>
    with AutomaticKeepAliveClientMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<List<_ActivityItem>>? _queueFuture;
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _queueFuture = _fetchAllQueues();
    });
  }

  Future<List<_ActivityItem>> _fetchAllQueues() async {
    final profile = HarbrProfile.current;
    final List<_ActivityItem> items = [];

    if (profile.radarrEnabled) {
      try {
        final client = Dio(BaseOptions(
          baseUrl: '${profile.radarrHost}/api/v3/',
          queryParameters: {
            if (profile.radarrKey != '') 'apikey': profile.radarrKey,
            'pageSize': 50,
            'includeMovie': true,
          },
          headers: profile.radarrHeaders,
        ));
        final response = await client.get('queue');
        final records = response.data['records'] as List? ?? [];
        for (final record in records) {
          items.add(_ActivityItem(
            service: 'Radarr',
            serviceColor: const Color(0xFFFEC333),
            serviceIcon: HarbrIcons.RADARR,
            title: record['title'] ?? 'Unknown',
            description: record['movie']?['title'] ?? '',
            progress: _calcProgress(record),
            size: _formatSize(record['size']?.toDouble()),
            quality: record['quality']?['quality']?['name'] ?? '',
            score: _formatScore(record['customFormatScore']),
            protocol: record['protocol'] ?? '',
            language: _extractLanguages(record['languages']),
            eta: record['timeleft'] ?? '',
            status: record['status'] ?? '',
          ));
        }
      } catch (_) {}
    }

    if (profile.sonarrEnabled) {
      try {
        final client = Dio(BaseOptions(
          baseUrl: '${profile.sonarrHost}/api/v3/',
          queryParameters: {
            if (profile.sonarrKey != '') 'apikey': profile.sonarrKey,
            'pageSize': 50,
            'includeSeries': true,
            'includeEpisode': true,
          },
          headers: profile.sonarrHeaders,
        ));
        final response = await client.get('queue');
        final records = response.data['records'] as List? ?? [];
        for (final record in records) {
          items.add(_ActivityItem(
            service: 'Sonarr',
            serviceColor: const Color(0xFF3FC6F4),
            serviceIcon: HarbrIcons.SONARR,
            title: record['title'] ?? 'Unknown',
            description: record['series']?['title'] ?? '',
            progress: _calcProgress(record),
            size: _formatSize(record['size']?.toDouble()),
            quality: record['quality']?['quality']?['name'] ?? '',
            score: _formatScore(record['customFormatScore']),
            protocol: record['protocol'] ?? '',
            language: _extractLanguages(record['languages']),
            eta: record['timeleft'] ?? '',
            status: record['status'] ?? '',
          ));
        }
      } catch (_) {}
    }

    if (profile.readarrEnabled) {
      try {
        final client = Dio(BaseOptions(
          baseUrl: '${profile.readarrHost}/api/v1/',
          queryParameters: {
            if (profile.readarrKey != '') 'apikey': profile.readarrKey,
            'pageSize': 50,
          },
          headers: profile.readarrHeaders,
        ));
        final response = await client.get('queue');
        final records = response.data['records'] as List? ?? [];
        for (final record in records) {
          items.add(_ActivityItem(
            service: 'Readarr',
            serviceColor: const Color(0xFF7B68EE),
            serviceIcon: Icons.book_rounded,
            title: record['title'] ?? 'Unknown',
            description: '',
            progress: _calcProgress(record),
            size: _formatSize(record['size']?.toDouble()),
            quality: record['quality']?['quality']?['name'] ?? '',
            score: _formatScore(record['customFormatScore']),
            protocol: record['protocol'] ?? '',
            language: _extractLanguages(record['languages']),
            eta: record['timeleft'] ?? '',
            status: record['status'] ?? '',
          ));
        }
      } catch (_) {}
    }

    return items;
  }

  double _calcProgress(Map<String, dynamic> record) {
    final double size = record['size']?.toDouble() ?? 0.0;
    final double sizeleft = record['sizeleft']?.toDouble() ?? 0.0;
    if (size == 0) return 0.0;
    return (1.0 - (sizeleft / size)).clamp(0.0, 1.0);
  }

  String _formatSize(double? bytes) {
    if (bytes == null || bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatScore(dynamic score) {
    if (score == null) return '';
    final int value = score is int ? score : (score as num).toInt();
    return value >= 0 ? '+$value' : '$value';
  }

  String _extractLanguages(dynamic languages) {
    if (languages == null) return '';
    if (languages is List) {
      final names = languages
          .map((lang) {
            if (lang is Map) return lang['name']?.toString() ?? '';
            return lang.toString();
          })
          .where((name) => name.isNotEmpty)
          .toList();
      return names.join(', ');
    }
    return languages.toString();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final harbr = context.harbr;

    return Column(
      children: [
        HarbrFilterActionBar(
          leadingAction: HarbrFilterAction(
            icon: Icons.schedule_rounded,
            label: 'Activity',
            onTap: _refresh,
          ),
          trailingActions: [
            HarbrFilterAction(
              icon: Icons.swap_vert_rounded,
              onTap: () {},
            ),
            HarbrFilterAction(
              icon: Icons.menu_rounded,
              onTap: () {},
            ),
          ],
        ),
        HarbrSearchField(
          hintText: 'Search activities...',
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        Expanded(
          child: FutureBuilder<List<_ActivityItem>>(
            future: _queueFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const HarbrLoader();
              }

              if (snapshot.hasError) {
                return const HarbrEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Failed to load queue',
                  subtitle: 'Pull to refresh and try again.',
                );
              }

              final items = snapshot.data ?? [];
              final filtered = _searchQuery.isEmpty
                  ? items
                  : items
                      .where((item) =>
                          item.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          item.description
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          item.service
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .toList();

              if (filtered.isEmpty) {
                return HarbrEmptyState(
                  icon: Icons.download_rounded,
                  title: items.isEmpty
                      ? 'No Active Downloads'
                      : 'No Matching Results',
                  subtitle: items.isEmpty
                      ? 'Queue activity from all services will appear here.'
                      : 'Try a different search term.',
                );
              }

              return RefreshIndicator(
                key: _refreshKey,
                onRefresh: () async => _refresh(),
                color: harbr.accent,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: HarbrTokens.xl),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _ActivityCard(item: filtered[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  final String service;
  final Color serviceColor;
  final IconData serviceIcon;
  final String title;
  final String description;
  final double progress;
  final String size;
  final String quality;
  final String score;
  final String protocol;
  final String language;
  final String eta;
  final String status;

  const _ActivityItem({
    required this.service,
    required this.serviceColor,
    required this.serviceIcon,
    required this.title,
    required this.description,
    required this.progress,
    required this.size,
    required this.quality,
    required this.score,
    required this.protocol,
    required this.language,
    required this.eta,
    required this.status,
  });
}

class _ActivityCard extends StatelessWidget {
  final _ActivityItem item;

  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final progressPercent = (item.progress * 100).toInt();

    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadiusXxl,
      showBorder: true,
      margin: HarbrTokens.paddingCard,
      padding: const EdgeInsets.all(HarbrTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service badge with icon + name
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.serviceColor.withValues(alpha: 0.2),
              borderRadius: HarbrTokens.borderRadiusPill,
              border: Border.all(color: item.serviceColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.serviceIcon,
                  size: 12,
                  color: item.serviceColor,
                ),
                const SizedBox(width: 6),
                Text(
                  item.service,
                  style: TextStyle(
                    color: item.serviceColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HarbrTokens.md),

          // Title (line-clamp-2)
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Description text below title
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: HarbrTokens.xs),
            Text(
              item.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: HarbrTokens.lg),

          // Progress label row: "Progress" left, percentage right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  color: harbr.onSurfaceDim,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: HarbrTokens.xs),

          // Progress bar (h-1 = 4px, bg-[#2d2540] track with orange fill)
          HarbrProgressBar(
            progress: item.progress,
            height: 4,
            color: item.serviceColor,
          ),

          const SizedBox(height: HarbrTokens.lg),

          // Detail rows: icon + label + dot + value
          ..._buildDetailRows(harbr),
        ],
      ),
    );
  }

  List<Widget> _buildDetailRows(HarbrThemeData harbr) {
    final details = <_DetailRowData>[
      if (item.size.isNotEmpty)
        _DetailRowData(
          icon: Icons.storage_rounded,
          label: 'Size',
          value: item.size,
        ),
      if (item.quality.isNotEmpty)
        _DetailRowData(
          icon: Icons.high_quality_rounded,
          label: 'Quality',
          value: item.quality,
        ),
      if (item.score.isNotEmpty)
        _DetailRowData(
          icon: Icons.star_rounded,
          label: 'Score',
          value: item.score,
        ),
      if (item.protocol.isNotEmpty)
        _DetailRowData(
          icon: Icons.sync_rounded,
          label: 'Protocol',
          value: item.protocol,
        ),
      if (item.language.isNotEmpty)
        _DetailRowData(
          icon: Icons.language_rounded,
          label: 'Language',
          value: item.language,
        ),
      if (item.eta.isNotEmpty)
        _DetailRowData(
          icon: Icons.schedule_rounded,
          label: 'ETA',
          value: item.eta,
        ),
    ];

    return details
        .map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: HarbrTokens.sm),
              child: _DetailRow(detail: detail, harbr: harbr),
            ))
        .toList();
  }
}

class _DetailRowData {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRowData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _DetailRow extends StatelessWidget {
  final _DetailRowData detail;
  final HarbrThemeData harbr;

  const _DetailRow({
    required this.detail,
    required this.harbr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          detail.icon,
          size: 16,
          color: harbr.onSurfaceDim,
        ),
        const SizedBox(width: HarbrTokens.md),
        Text(
          detail.label,
          style: TextStyle(
            color: harbr.onSurfaceDim,
            fontSize: 13,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.sm),
          child: Text(
            '\u00b7',
            style: TextStyle(
              color: harbr.onSurfaceDim,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            detail.value,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
