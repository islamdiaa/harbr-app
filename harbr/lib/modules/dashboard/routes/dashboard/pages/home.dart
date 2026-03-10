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
  const HomePage({Key? key}) : super(key: key);

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
        horizontal: HarbrTokens.md,
        vertical: HarbrTokens.lg,
      ),
      children: [
        // 1. Network Selector Row
        _buildNetworkSelectorRow(context),
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
          showIndicator: _hasServices,
          showOverflow: _hasServices,
        ),
        const SizedBox(height: HarbrTokens.sm),
        _buildUpcomingReleases(context),
        const SizedBox(height: HarbrTokens.xl),

        // 4. Currently Playing Section
        _buildSectionHeader(
            context, 'Currently Playing', showOverflow: _hasServices),
        const SizedBox(height: HarbrTokens.sm),
        _buildCurrentlyPlaying(context),
        const SizedBox(height: HarbrTokens.xl),

        // 5. Latest Downloads Section
        _buildSectionHeader(
          context,
          'Latest Downloads',
          showIndicator: _hasServices,
          showOverflow: _hasServices,
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

  // ── 1. Network Selector Row ───────────────────────────────────────

  Widget _buildNetworkSelectorRow(BuildContext context) {
    final harbr = context.harbr;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: HarbrTokens.xl,
              vertical: HarbrTokens.md,
            ),
            decoration: BoxDecoration(
              color: harbr.surface0,
              borderRadius: HarbrTokens.borderRadiusPill,
              border: Border.all(color: harbr.border),
            ),
            child: Text(
              'Default Network',
              style: TextStyle(
                color: harbr.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => HarbrRoutes.settings.root.go(buildTree: true),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: harbr.surface0,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings_rounded,
                color: harbr.onSurfaceDim,
                size: HarbrTokens.iconMd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool showIndicator = false,
    bool showOverflow = false,
  }) {
    final harbr = context.harbr;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xs),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showIndicator) ...[
            const SizedBox(width: HarbrTokens.sm),
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: HarbrColors.orange,
                borderRadius: HarbrTokens.borderRadiusPill,
              ),
            ),
          ],
          const Spacer(),
          if (showOverflow)
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.more_vert_rounded,
                color: harbr.onSurfaceDim,
                size: HarbrTokens.iconMd,
              ),
            ),
        ],
      ),
    );
  }

  // ── Empty state card ──────────────────────────────────────────────

  Widget _emptyCard(BuildContext context, String text, {bool tapToSettings = false}) {
    final harbr = context.harbr;
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
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

    return Column(
      children: enabledModules
          .take(6)
          .map((module) => Padding(
                padding: const EdgeInsets.only(bottom: HarbrTokens.sm),
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
            Color(0xFF8B7FB8),
            Color(0xFF7C4DFF),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(HarbrThemeData harbr) {
    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadiusXxl,
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
      borderRadius: HarbrTokens.borderRadiusXxl,
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
              Color(0xFFFF9000),
              Color(0xFFFF6B00),
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
      borderRadius: HarbrTokens.borderRadiusXxl,
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
      borderRadius: HarbrTokens.borderRadiusXxl,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: HarbrTokens.paddingXl,
      onTap: module.launch,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: module.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: HarbrTokens.sm),
              Expanded(
                child: Text(
                  module.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.wifi_rounded,
                color: harbr.success,
                size: HarbrTokens.iconMd,
              ),
              const SizedBox(width: HarbrTokens.sm),
              Icon(
                Icons.remove_rounded,
                color: harbr.onSurfaceDim,
                size: HarbrTokens.iconMd,
              ),
            ],
          ),
          const SizedBox(height: HarbrTokens.md),
          // Stats rows — populated with real data when available
          _ServiceStatRow(
            icon: Icons.movie_rounded,
            label: 'Movies',
            value: '—',
            harbr: harbr,
          ),
          const SizedBox(height: HarbrTokens.xs),
          _ServiceStatRow(
            icon: Icons.insert_drive_file_rounded,
            label: 'Files',
            value: '—',
            harbr: harbr,
          ),
          const SizedBox(height: HarbrTokens.xs),
          _ServiceStatRow(
            icon: Icons.storage_rounded,
            label: 'Size',
            value: '—',
            harbr: harbr,
          ),
        ],
      ),
    );
  }
}

class _ServiceStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final HarbrThemeData harbr;

  const _ServiceStatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.harbr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: harbr.onSurfaceDim, size: HarbrTokens.iconSm),
        const SizedBox(width: HarbrTokens.sm),
        Text(
          label,
          style: TextStyle(
            color: harbr.onSurfaceDim,
            fontSize: 14,
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
          value,
          style: TextStyle(
            color: harbr.onSurface,
            fontSize: 14,
          ),
        ),
      ],
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
