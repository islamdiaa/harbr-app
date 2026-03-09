import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrDrawerHeader extends StatelessWidget {
  final String page;

  const HarbrDrawerHeader({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => Container(
        child: HarbrAppBar.dropdown(
          backgroundColor: Colors.transparent,
          hideLeading: true,
          useDrawer: false,
          title: HarbrBox.profiles.keys.length == 1
              ? 'Harbr'
              : HarbrDatabase.ENABLED_PROFILE.read(),
          profiles: HarbrBox.profiles.keys.cast<String>().toList(),
          actions: [
            HarbrIconButton(
              icon: HarbrIcons.SETTINGS,
              onPressed: page == HarbrModule.SETTINGS.key
                  ? Navigator.of(context).pop
                  : HarbrModule.SETTINGS.launch,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: HarbrColours.accent,
          image: DecorationImage(
            image: const AssetImage(HarbrAssets.brandingLogo),
            colorFilter: ColorFilter.mode(
              HarbrColours.primary.withOpacity(0.15),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
