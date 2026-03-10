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

  @override
  bool get wantKeepAlive => true;

  bool get _hasServices =>
      HarbrModule.active.any((m) => m.isEnabled);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
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
      borderRadius: HarbrTokens.borderRadiusXxl,
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
              borderRadius: HarbrTokens.borderRadiusXl,
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
