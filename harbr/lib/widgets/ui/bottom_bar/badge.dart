import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrNavigationBarBadge extends badges.Badge {
  HarbrNavigationBarBadge({
    Key? key,
    required String text,
    required IconData icon,
    required bool showBadge,
    required bool isActive,
  }) : super(
          key: key,
          badgeStyle: badges.BadgeStyle(
            badgeColor: HarbrColours.accent.dimmed(),
            elevation: HarbrUI.ELEVATION,
            shape: badges.BadgeShape.circle,
          ),
          badgeAnimation: const badges.BadgeAnimation.scale(
            animationDuration:
                Duration(milliseconds: HarbrUI.ANIMATION_SPEED_SCROLLING),
          ),
          position: badges.BadgePosition.topEnd(
            top: -HarbrUI.DEFAULT_MARGIN_SIZE,
            end: -HarbrUI.DEFAULT_MARGIN_SIZE,
          ),
          badgeContent: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          child: Icon(
            icon,
            color: isActive ? HarbrColours.accent : Colors.white,
          ),
          showBadge: showBadge,
        );
}
