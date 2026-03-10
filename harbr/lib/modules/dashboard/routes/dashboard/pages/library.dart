import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/filter_action_bar.dart';
import 'package:harbr/widgets/ui/search_field.dart';
import 'package:harbr/widgets/ui/empty_state.dart';

/// Library page matching the Figma Library.tsx spec.
///
/// Shows the catalogue of movies/series from configured services.
/// When no services are configured, shows an appropriate empty state.
class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with AutomaticKeepAliveClientMixin {
  String _searchQuery = '';
  String _mediaType = 'movies';
  String _filter = 'all';

  @override
  bool get wantKeepAlive => true;

  bool get _hasServices =>
      HarbrModule.active.any((m) => m.isEnabled);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final harbr = context.harbr;

    return Column(
      children: [
        // SafeArea top padding (no appbar)
        SafeArea(bottom: false, child: const SizedBox(height: HarbrTokens.lg)),

        // Header: "Library" + stats + add buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
          child: Row(
            children: [
              Text(
                'Library',
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Stats button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: harbr.surface0,
                    borderRadius: HarbrTokens.borderRadius12,
                    border: Border.all(color: harbr.border),
                  ),
                  child: Icon(
                    Icons.bar_chart_rounded,
                    color: harbr.onSurfaceDim,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: HarbrTokens.sm),
              // Add button (orange)
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: harbr.accent,
                    borderRadius: HarbrTokens.borderRadius12,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: HarbrTokens.lg),

        // Media type tabs (Movies / TV Shows)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
          child: Row(
            children: [
              _buildMediaTypeTab(harbr, 'movies', 'Movies'),
              const SizedBox(width: HarbrTokens.sm),
              _buildMediaTypeTab(harbr, 'tv_shows', 'TV Shows'),
            ],
          ),
        ),
        const SizedBox(height: HarbrTokens.lg),

        HarbrFilterActionBar(
          leadingAction: HarbrFilterAction(
            icon: Icons.add_rounded,
            label: 'Add',
            onTap: () {},
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
          hintText: 'Search library...',
          onChanged: (value) => setState(() => _searchQuery = value),
        ),

        // Filter pills (All / Complete / Missing / Upcoming)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill(harbr, 'all', 'All'),
                const SizedBox(width: HarbrTokens.sm),
                _buildFilterPill(harbr, 'complete', 'Complete'),
                const SizedBox(width: HarbrTokens.sm),
                _buildFilterPill(harbr, 'missing', 'Missing'),
                const SizedBox(width: HarbrTokens.sm),
                _buildFilterPill(harbr, 'upcoming', 'Upcoming'),
              ],
            ),
          ),
        ),
        const SizedBox(height: HarbrTokens.lg),

        Expanded(
          child: _hasServices
              ? _buildServiceEntries(context)
              : const HarbrEmptyState(
                  icon: Icons.video_library_rounded,
                  title: 'No Library',
                  subtitle:
                      'Connect a service like Radarr or Sonarr to browse your media library.',
                ),
        ),
      ],
    );
  }

  /// When services are configured, show them as entry points to their
  /// respective catalogues.
  Widget _buildServiceEntries(BuildContext context) {
    final harbr = context.harbr;
    final enabledModules = HarbrModule.active
        .where((m) => m.isEnabled)
        .where((m) {
          if (_searchQuery.isEmpty) return true;
          return m.title.toLowerCase().contains(_searchQuery.toLowerCase());
        })
        .toList();

    if (enabledModules.isEmpty) {
      return const HarbrEmptyState(
        icon: Icons.search_off_rounded,
        title: 'No Matching Results',
        subtitle: 'Try a different search term.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: HarbrTokens.md,
        right: HarbrTokens.md,
        bottom: HarbrTokens.xl,
      ),
      itemCount: enabledModules.length,
      itemBuilder: (context, index) {
        final module = enabledModules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: HarbrTokens.sm),
          child: _LibraryServiceCard(module: module),
        );
      },
    );
  }

  /// Builds a media-type tab pill ("Movies" or "TV Shows").
  Widget _buildMediaTypeTab(HarbrThemeData harbr, String value, String label) {
    final isActive = _mediaType == value;
    return GestureDetector(
      onTap: () => setState(() => _mediaType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? harbr.accent : harbr.surface0,
          borderRadius: HarbrTokens.borderRadiusPill,
          border: isActive ? null : Border.all(color: harbr.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : harbr.onSurfaceDim,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Builds a filter pill ("All", "Complete", "Missing", "Upcoming").
  Widget _buildFilterPill(HarbrThemeData harbr, String value, String label) {
    final isActive = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? harbr.surface2 : harbr.surface0,
          borderRadius: HarbrTokens.borderRadiusPill,
          border: Border.all(
            color: isActive
                ? harbr.onSurface.withValues(alpha: 0.2)
                : harbr.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? harbr.onSurface : harbr.onSurfaceDim,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// A service entry card for the Library tab.
///
/// Styled as a bordered card matching the Figma Library.tsx movie cards,
/// but showing the service name and a prompt to browse.
class _LibraryServiceCard extends StatelessWidget {
  final HarbrModule module;

  const _LibraryServiceCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadius12,
      showBorder: true,
      margin: EdgeInsets.zero,
      padding: HarbrTokens.paddingXl,
      onTap: module.launch,
      child: Row(
        children: [
          // Service icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: module.color.withValues(alpha: 0.15),
              borderRadius: HarbrTokens.borderRadius12,
            ),
            child: Icon(
              module.icon,
              color: module.color,
              size: HarbrTokens.iconLg,
            ),
          ),
          const SizedBox(width: HarbrTokens.lg),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: HarbrTokens.xs),
                Text(
                  module.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: harbr.onSurfaceFaint,
            size: HarbrTokens.iconLg,
          ),
        ],
      ),
    );
  }
}
