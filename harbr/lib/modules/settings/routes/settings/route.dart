import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsRoute> createState() => _State();
}

class _State extends State<SettingsRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      drawer: _drawer(),
      body: _body(),
    );
  }

  Widget _drawer() => HarbrDrawer(page: HarbrModule.SETTINGS.key);

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      useDrawer: true,
      scrollControllers: [scrollController],
      title: HarbrModule.SETTINGS.title,
    );
  }

  Widget _body() {
    final harbr = context.harbr;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
      children: [
        const SizedBox(height: HarbrTokens.sm),

        // Modal-style container matching Figma Settings.tsx
        Container(
          decoration: BoxDecoration(
            color: harbr.surface0,
            borderRadius: HarbrTokens.borderRadius12,
            border: Border.all(color: harbr.border),
          ),
          child: Column(
            children: [
              // Drag indicator
              Padding(
                padding: const EdgeInsets.only(top: HarbrTokens.lg),
                child: Container(
                  width: 64,
                  height: 4,
                  decoration: BoxDecoration(
                    color: harbr.onSurfaceFaint,
                    borderRadius: HarbrTokens.borderRadiusPill,
                  ),
                ),
              ),

              // Modal header: title + close button (Figma Settings.tsx)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HarbrTokens.xl,
                  vertical: HarbrTokens.lg,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: HarbrTokens.xl),
                    const Spacer(),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: harbr.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Icon(
                        Icons.close_rounded,
                        color: harbr.onSurface,
                        size: HarbrTokens.iconLg,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: HarbrTokens.md),

              // Membership card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xl),
                child: _MembershipCard(harbr: harbr),
              ),

              const SizedBox(height: HarbrTokens.xl),

              // Main menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xl),
                child: Column(
                  children: [
                    _SettingsMenuItem(
                      label: 'Configuration',
                      icon: Icons.dns_rounded,
                      color: HarbrColors.success,
                      onTap: SettingsRoutes.CONFIGURATION.go,
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'Profiles',
                      icon: Icons.people_rounded,
                      color: HarbrColors.info,
                      onTap: SettingsRoutes.PROFILES.go,
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'Look & Feel',
                      icon: Icons.palette_rounded,
                      color: HarbrColors.purple,
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'Security',
                      icon: Icons.lock_rounded,
                      color: HarbrColors.danger,
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'Advanced',
                      icon: Icons.settings_rounded,
                      color: HarbrColors.orange,
                      onTap: SettingsRoutes.SYSTEM.go,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: HarbrTokens.xl),

              // External links
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xl),
                child: Column(
                  children: [
                    _SettingsMenuItem(
                      label: 'Join Discord',
                      icon: Icons.chat_bubble_rounded,
                      color: HarbrColors.blue,
                      trailing: Icons.open_in_new_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'Support & Feedback',
                      icon: Icons.email_rounded,
                      color: HarbrColors.info,
                      trailing: Icons.open_in_new_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: HarbrTokens.xl),

              // Additional items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.xl),
                child: Column(
                  children: [
                    _SettingsMenuItem(
                      label: 'Extras',
                      icon: Icons.auto_awesome_rounded,
                      color: HarbrColors.purple,
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.space2),
                    _SettingsMenuItem(
                      label: 'About',
                      icon: Icons.info_rounded,
                      color: HarbrColors.info,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: HarbrTokens.xl),
            ],
          ),
        ),

        const SizedBox(height: HarbrTokens.xl),
      ],
    );
  }
}

/// Membership card matching Figma SettingsModal design — horizontal layout.
class _MembershipCard extends StatelessWidget {
  final HarbrThemeData harbr;

  const _MembershipCard({required this.harbr});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HarbrTokens.lg),
      decoration: BoxDecoration(
        color: harbr.surface2,
        borderRadius: HarbrTokens.borderRadius12,
      ),
      child: Row(
        children: [
          // Crown avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: harbr.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: harbr.accent,
              size: HarbrTokens.iconMd,
            ),
          ),
          const SizedBox(width: HarbrTokens.md),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HELMARR',
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'FREE tier',
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Upgrade pill button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: harbr.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A menu row matching Figma SettingsModal — flat colored icon, no card wrapper.
class _SettingsMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final IconData? trailing;

  const _SettingsMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Flat colored icon — no background square
            Icon(
              icon,
              color: color,
              size: HarbrTokens.iconMd,
            ),
            const SizedBox(width: HarbrTokens.md),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              trailing ?? Icons.chevron_right_rounded,
              color: harbr.onSurfaceDim.withValues(alpha: 0.5),
              size: HarbrTokens.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
