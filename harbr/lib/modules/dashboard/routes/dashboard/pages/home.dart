import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/icon_circle.dart';
import 'package:harbr/widgets/ui/gradient_progress_bar.dart';
import 'package:harbr/widgets/ui/poster_carousel.dart';
import 'package:harbr/widgets/ui/bar_chart_card.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';

class HomePage extends StatefulWidget {
  /// Callback to switch the dashboard bottom nav tab.
  final ValueChanged<int>? onSwitchTab;

  const HomePage({Key? key, this.onSwitchTab}) : super(key: key);

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool get _hasServices =>
      HarbrModule.active.any((m) => m.isEnabled);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.lg,
      ),
      children: [
        // SafeArea top padding (no appbar)
        SafeArea(bottom: false, child: const SizedBox(height: HarbrTokens.xl)),

        // 1. Header Row
        _buildHeader(context),
        const SizedBox(height: HarbrTokens.xl),

        // 2. Services Section
        _buildSectionHeader(context, 'Services', showOverflow: _hasServices),
        const SizedBox(height: HarbrTokens.sm),
        _buildServicesSection(context),
        const SizedBox(height: HarbrTokens.xl),

        // 3. Upcoming Releases Section
        _buildSectionHeader(
          context,
          'Upcoming Releases',
          showOverflow: _hasServices,
          onViewAll: () => widget.onSwitchTab?.call(2), // Calendar tab
        ),
        const SizedBox(height: HarbrTokens.sm),
        _buildUpcomingReleases(context),
        const SizedBox(height: HarbrTokens.xl),

        // 4. Currently Downloading Section
        _buildSectionHeader(
          context,
          'Currently Downloading',
          showOverflow: _hasServices,
          onViewAll: () => widget.onSwitchTab?.call(3), // Activities tab
        ),
        const SizedBox(height: HarbrTokens.sm),
        _buildCurrentlyPlaying(context),
        const SizedBox(height: HarbrTokens.xl),

        // 5. Latest Downloads Section
        _buildSectionHeader(
          context,
          'Latest Downloads',
          showOverflow: _hasServices,
          onViewAll: () => widget.onSwitchTab?.call(1), // Library tab
        ),
        const SizedBox(height: HarbrTokens.sm),
        _buildLatestDownloads(context),
        const SizedBox(height: HarbrTokens.xl),

        // 6. Library Statistics Section
        _buildSectionHeader(
          context,
          'Library Statistics',
          showIndicator: _hasServices,
          showOverflow: _hasServices,
        ),
        const SizedBox(height: HarbrTokens.sm),
        _buildLibraryStatistics(context),
        const SizedBox(height: HarbrTokens.xl),

        // 7. Status Summary Section
        _buildSectionHeader(context, 'Status Summary'),
        const SizedBox(height: HarbrTokens.sm),
        _buildStatusSummary(context),
        const SizedBox(height: HarbrTokens.xl),
      ],
    );
  }

  // ── 1. Header Row (Figma-aligned) ─────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final harbr = context.harbr;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'harbr',
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your media at a glance',
                style: TextStyle(
                  color: harbr.onSurfaceDim,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        _headerIconButton(
          context,
          icon: Icons.search_rounded,
          onTap: () {
            // Switch to Library tab (index 1)
          },
        ),
        const SizedBox(width: HarbrTokens.sm),
        _headerIconButton(
          context,
          icon: Icons.settings_rounded,
          onTap: () => HarbrRoutes.settings.root.go(buildTree: true),
        ),
      ],
    );
  }

  Widget _headerIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final harbr = context.harbr;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: harbr.surface0,
          borderRadius: HarbrTokens.borderRadius12,
          border: Border.all(color: harbr.border),
        ),
        child: Icon(
          icon,
          color: harbr.onSurfaceDim,
          size: 16,
        ),
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool showIndicator = false,
    bool showOverflow = false,
    VoidCallback? onViewAll,
  }) {
    final harbr = context.harbr;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: harbr.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (showOverflow && onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: harbr.accent, // orange
                    fontSize: 12,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: harbr.accent,
                  size: 12,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Empty state card ──────────────────────────────────────────────

  Widget _emptyCard(BuildContext context, String text, {bool tapToSettings = false}) {
    final harbr = context.harbr;
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(HarbrTokens.xl),
      onTap: tapToSettings
          ? () => HarbrRoutes.settings.root.go(buildTree: true)
          : null,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: harbr.onSurfaceDim,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ── 2. Services Section ───────────────────────────────────────────

  Widget _buildServicesSection(BuildContext context) {
    final enabledModules =
        HarbrModule.active.where((m) => m.isEnabled).toList();

    if (enabledModules.isEmpty) {
      return _emptyCard(
        context,
        'No services configured.\nTap to add your first service.',
        tapToSettings: true,
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: enabledModules
          .take(6)
          .map((module) => SizedBox(
                width: (MediaQuery.of(context).size.width - 42) / 2, // 2-col grid with gaps
                child: _ServiceCard(module: module),
              ))
          .toList(),
    );
  }

  // ── 3. Upcoming Releases Section ──────────────────────────────────

  Widget _buildUpcomingReleases(BuildContext context) {
    if (!_hasServices) {
      return _emptyCard(context, 'Connect services to see upcoming releases.');
    }
    return _emptyCard(context, 'No upcoming releases');
  }

  // ── 4. Currently Playing Section ──────────────────────────────────

  Widget _buildCurrentlyPlaying(BuildContext context) {
    return _emptyCard(
      context,
      'Streaming activity is provided by Tautulli or Jellystat. '
      'Add one of these services to enable this feature.',
    );
  }

  // ── 5. Latest Downloads Section ───────────────────────────────────

  Widget _buildLatestDownloads(BuildContext context) {
    if (!_hasServices) {
      return _emptyCard(
          context, 'Connect services to see latest downloads.');
    }
    // TODO: fetch real recent downloads from enabled services
    return _emptyCard(context, 'No recent downloads');
  }

  // ── 6. Library Statistics Section ─────────────────────────────────

  Widget _buildLibraryStatistics(BuildContext context) {
    if (!_hasServices) {
      return _emptyCard(
          context, 'Connect services to see library statistics.');
    }
    final harbr = context.harbr;
    // TODO: fetch real stats from enabled services
    return Column(
      children: [
        _buildOverviewCard(harbr),
        const SizedBox(height: HarbrTokens.sm),
        _buildCompletenessCard(harbr),
        const SizedBox(height: HarbrTokens.sm),
        HarbrBarChartCard(
          title: 'Top Movie / TV Genres',
          items: const [],
          initialVisibleCount: 5,
          gradientColors: const [
            HarbrColors.accent,
            HarbrColors.orange,
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(HarbrThemeData harbr) {
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: HarbrTokens.paddingXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: HarbrTokens.lg),
          Row(
            children: [
              Expanded(
                child: _OverviewStatTile(
                  icon: Icons.movie_rounded,
                  iconColor: HarbrColors.orange,
                  label: 'Movies',
                  value: '—',
                  harbr: harbr,
                ),
              ),
              const SizedBox(width: HarbrTokens.lg),
              Expanded(
                child: _OverviewStatTile(
                  icon: Icons.storage_rounded,
                  iconColor: HarbrColors.info,
                  label: 'Storage',
                  value: '—',
                  harbr: harbr,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletenessCard(HarbrThemeData harbr) {
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: HarbrTokens.paddingXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completeness',
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: HarbrTokens.lg),
          Row(
            children: [
              Icon(
                Icons.movie_rounded,
                color: HarbrColors.orange,
                size: HarbrTokens.iconSm,
              ),
              const SizedBox(width: HarbrTokens.xs),
              Text(
                'Movies',
                style: TextStyle(
                  color: harbr.onSurfaceDim,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '—',
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: HarbrTokens.sm),
          const HarbrGradientProgressBar(
            progress: 0.0,
            height: 12,
            gradientColors: [
              HarbrColors.accent,
              HarbrColors.orange,
            ],
          ),
          const SizedBox(height: HarbrTokens.xs),
          Text(
            'No data available',
            style: TextStyle(
              color: harbr.onSurfaceFaint,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── 7. Status Summary Section ─────────────────────────────────────

  Widget _buildStatusSummary(BuildContext context) {
    final harbr = context.harbr;
    if (!_hasServices) {
      return _emptyCard(context, 'Connect services to see status summary.');
    }
    // TODO: fetch real counts from enabled services
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: HarbrTokens.paddingXl,
      child: Column(
        children: [
          _StatusRow(
            icon: Icons.check_circle_rounded,
            color: harbr.success,
            label: 'Available',
            count: '—',
          ),
          const SizedBox(height: HarbrTokens.md),
          _StatusRow(
            icon: Icons.warning_rounded,
            color: harbr.warning,
            label: 'Missing',
            count: '—',
          ),
          const SizedBox(height: HarbrTokens.md),
          _StatusRow(
            icon: Icons.movie_rounded,
            color: harbr.info,
            label: 'Upcoming',
            count: '—',
          ),
        ],
      ),
    );
  }
}

// ── Service Card (full-width, Figma spec) ─────────────────────────────

class _ServiceCard extends StatelessWidget {
  final HarbrModule module;
  const _ServiceCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      onTap: module.launch,
      child: Row(
        children: [
          // Colored icon square (36x36, rounded-lg, color at 12%)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: module.color.withValues(alpha: 0.12),
              borderRadius: HarbrTokens.borderRadiusSm,
            ),
            child: Icon(
              Icons.dns_rounded,
              color: module.color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 13,
                  ),
                ),
                Text(
                  module.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Overview stat tile (for 2-column grid) ────────────────────────────

class _OverviewStatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final HarbrThemeData harbr;

  const _OverviewStatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.harbr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: HarbrTokens.iconSm),
            const SizedBox(width: HarbrTokens.xs),
            Text(
              label,
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: HarbrTokens.xs),
        Text(
          value,
          style: TextStyle(
            color: harbr.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Status row (icon circle + label + dot + count) ────────────────────

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String count;

  const _StatusRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    return Row(
      children: [
        HarbrIconCircle(icon: icon, color: color, size: 32),
        const SizedBox(width: HarbrTokens.md),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          HarbrUI.TEXT_BULLET,
          style: TextStyle(
            color: harbr.onSurfaceFaint,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: HarbrTokens.xs),
        Text(
          count,
          style: TextStyle(
            color: harbr.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
