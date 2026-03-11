import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbr/core.dart';

enum HarbrSnackbarType {
  SUCCESS,
  ERROR,
  INFO,
}

extension HarbrSnackbarTypeExtension on HarbrSnackbarType {
  Color get color {
    switch (this) {
      case HarbrSnackbarType.SUCCESS:
        return HarbrColors.success;
      case HarbrSnackbarType.ERROR:
        return HarbrColors.danger;
      case HarbrSnackbarType.INFO:
        return HarbrColors.info;
      default:
        return HarbrColors.navActive;
    }
  }

  IconData get icon {
    switch (this) {
      case HarbrSnackbarType.SUCCESS:
        return Icons.check_circle_outline_rounded;
      case HarbrSnackbarType.ERROR:
        return Icons.error_outline_rounded;
      case HarbrSnackbarType.INFO:
        return Icons.info_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

Future<void> showHarbrSnackBar({
  required String title,
  required HarbrSnackbarType type,
  required String message,
  Duration? duration,
  FlashPosition position = FlashPosition.bottom,
  bool showButton = false,
  String buttonText = 'view',
  Function? buttonOnPressed,
}) async {
  showFlash(
    context: HarbrState.context,
    duration: duration ?? Duration(seconds: showButton ? 4 : 2),
    transitionDuration: const Duration(milliseconds: HarbrUI.ANIMATION_SPEED),
    reverseTransitionDuration:
        const Duration(milliseconds: HarbrUI.ANIMATION_SPEED),
    builder: (context, controller) => FlashBar(
      controller: controller,
      backgroundColor: Theme.of(context).primaryColor,
      behavior: FlashBehavior.floating,
      margin: HarbrUI.MARGIN_DEFAULT,
      position: position,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:
              HarbrUI.shouldUseBorder ? HarbrColours.white10 : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(HarbrUI.BORDER_RADIUS),
      ),
      title: HarbrText.title(
        text: title,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
      content: HarbrText.subtitle(
        text: message,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
      ),
      shouldIconPulse: false,
      icon: Padding(
        child: HarbrIconButton(
          icon: type.icon,
          color: type.color,
        ),
        padding: const EdgeInsets.only(
          left: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
        ),
      ),
      primaryAction: showButton
          ? TextButton(
              child: Text(
                buttonText.toUpperCase(),
                style: const TextStyle(
                  fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
                  color: HarbrColours.accent,
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.dismiss();
                buttonOnPressed!();
              },
            )
          : null,
    ),
  );
}
