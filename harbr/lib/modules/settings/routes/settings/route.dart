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
            color: harbr.deepSurface,
            borderRadius: HarbrTokens.borderRadiusXxl,
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
                      color: const Color(0xFF3FB950),
                      onTap: SettingsRoutes.CONFIGURATION.go,
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'Profiles',
                      icon: Icons.people_rounded,
                      color: const Color(0xFF58A6FF),
                      onTap: SettingsRoutes.PROFILES.go,
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'Look & Feel',
                      icon: Icons.palette_rounded,
                      color: const Color(0xFFE91E8C),
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'Security',
                      icon: Icons.lock_rounded,
                      color: const Color(0xFFF85149),
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'Advanced',
                      icon: Icons.settings_rounded,
                      color: const Color(0xFFFF9000),
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
                      color: const Color(0xFF5865F2),
                      trailing: Icons.open_in_new_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'Support & Feedback',
                      icon: Icons.email_rounded,
                      color: const Color(0xFF22D3EE),
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
                      color: const Color(0xFF7C4DFF),
                      onTap: () {},
                    ),
                    const SizedBox(height: HarbrTokens.md),
                    _SettingsMenuItem(
                      label: 'About',
                      icon: Icons.info_rounded,
                      color: const Color(0xFF22D3EE),
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

/// Membership card matching Figma Settings.tsx gradient card.
class _MembershipCard extends StatelessWidget {
  final HarbrThemeData harbr;

  const _MembershipCard({required this.harbr});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HarbrTokens.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade700,
            Colors.grey.shade600,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HARBR FREE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: HarbrTokens.lg),
          Text(
            'SERVICE ACCESS',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 11,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: HarbrTokens.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MEMBER SINCE',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
              Text(
                'HLMR-FREE',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A menu row matching Figma: canvas bg, rounded-2xl, colored icon square.
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

    return Material(
      color: harbr.canvas,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(HarbrTokens.lg),
          child: Row(
            children: [
              // Colored icon square (w-10 h-10 rounded-xl)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: HarbrTokens.borderRadiusLg,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: HarbrTokens.iconMd,
                ),
              ),
              const SizedBox(width: HarbrTokens.lg),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                trailing ?? Icons.chevron_right_rounded,
                color: harbr.onSurfaceFaint,
                size: HarbrTokens.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
