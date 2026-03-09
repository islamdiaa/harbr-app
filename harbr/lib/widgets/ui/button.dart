import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbr/system/state.dart';
import 'package:harbr/types/loading_state.dart';
import 'package:harbr/widgets/ui.dart';

enum HarbrButtonType {
  TEXT,
  ICON,
  LOADER,
}

/// A Harbr-styled button.
class HarbrButton extends Card {
  static const DEFAULT_HEIGHT = 46.0;

  HarbrButton._({
    Key? key,
    required Widget child,
    EdgeInsets margin = HarbrUI.MARGIN_HALF,
    Color? backgroundColor,
    double height = DEFAULT_HEIGHT,
    Alignment alignment = Alignment.center,
    Decoration? decoration,
    Function? onTap,
    Function? onLongPress,
    HarbrLoadingState? loadingState,
  }) : super(
          key: key,
          child: InkWell(
            child: Container(
              child: child,
              decoration: decoration,
              height: height,
              alignment: alignment,
            ),
            borderRadius: BorderRadius.circular(HarbrUI.BORDER_RADIUS),
            onTap: () async {
              HapticFeedback.lightImpact();
              if (onTap != null && loadingState != HarbrLoadingState.ACTIVE)
                onTap();
            },
            onLongPress: () async {
              HapticFeedback.heavyImpact();
              if (onLongPress != null &&
                  loadingState != HarbrLoadingState.ACTIVE) onLongPress();
            },
          ),
          margin: margin,
          color: backgroundColor != null
              ? backgroundColor.withOpacity(HarbrUI.OPACITY_DIMMED)
              : Theme.of(HarbrState.context)
                  .canvasColor
                  .withOpacity(HarbrUI.OPACITY_DIMMED),
          shape:
              backgroundColor != null ? HarbrShapeBorder() : HarbrUI.shapeBorder,
          elevation: HarbrUI.ELEVATION,
          clipBehavior: Clip.antiAlias,
        );

  /// Create a default button.
  ///
  /// If [HarbrLoadingState] is passed in, will build the correct button based on the type.
  factory HarbrButton({
    required HarbrButtonType type,
    Color color = HarbrColours.accent,
    Color? backgroundColor,
    String? text,
    IconData? icon,
    double iconSize = HarbrUI.ICON_SIZE,
    HarbrLoadingState? loadingState,
    EdgeInsets margin = HarbrUI.MARGIN_HALF,
    double height = DEFAULT_HEIGHT,
    Alignment alignment = Alignment.center,
    Decoration? decoration,
    Function? onTap,
    Function? onLongPress,
  }) {
    switch (loadingState) {
      case HarbrLoadingState.ACTIVE:
        return HarbrButton.loader(
          color: color,
          backgroundColor: backgroundColor,
          margin: margin,
          height: height,
          alignment: alignment,
          decoration: decoration,
          onTap: onTap,
          onLongPress: onLongPress,
          loadingState: loadingState,
        );
      case HarbrLoadingState.ERROR:
        return HarbrButton.icon(
          icon: Icons.error_rounded,
          iconSize: iconSize,
          color: color,
          backgroundColor: backgroundColor,
          margin: margin,
          height: height,
          alignment: alignment,
          decoration: decoration,
          onTap: onTap,
          onLongPress: onLongPress,
          loadingState: loadingState,
        );
      default:
        break;
    }
    switch (type) {
      case HarbrButtonType.TEXT:
        return HarbrButton.text(
          text: text!,
          icon: icon,
          iconSize: iconSize,
          color: color,
          backgroundColor: backgroundColor,
          margin: margin,
          height: height,
          alignment: alignment,
          decoration: decoration,
          onTap: onTap,
          onLongPress: onLongPress,
          loadingState: loadingState,
        );
      case HarbrButtonType.ICON:
        assert(icon != null);
        return HarbrButton.icon(
          icon: icon,
          iconSize: iconSize,
          color: color,
          backgroundColor: backgroundColor,
          margin: margin,
          height: height,
          alignment: alignment,
          decoration: decoration,
          onTap: onTap,
          onLongPress: onLongPress,
          loadingState: loadingState,
        );
      case HarbrButtonType.LOADER:
        return HarbrButton.loader(
          color: color,
          backgroundColor: backgroundColor,
          margin: margin,
          height: height,
          alignment: alignment,
          decoration: decoration,
          onTap: onTap,
          onLongPress: onLongPress,
          loadingState: loadingState,
        );
    }
  }

  /// Build a button that contains a centered text string.
  factory HarbrButton.text({
    required String text,
    required IconData? icon,
    double iconSize = HarbrUI.ICON_SIZE,
    Color color = HarbrColours.accent,
    Color? backgroundColor,
    EdgeInsets margin = HarbrUI.MARGIN_HALF,
    double height = DEFAULT_HEIGHT,
    Alignment alignment = Alignment.center,
    Decoration? decoration,
    HarbrLoadingState? loadingState,
    Function? onTap,
    Function? onLongPress,
  }) {
    return HarbrButton._(
      child: Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                child: Icon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
                padding: const EdgeInsets.only(
                    right: HarbrUI.DEFAULT_MARGIN_SIZE / 2),
              ),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
                  fontSize: HarbrUI.FONT_SIZE_H3,
                ),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          ],
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: HarbrUI.DEFAULT_MARGIN_SIZE),
      ),
      margin: margin,
      height: height,
      backgroundColor: backgroundColor,
      alignment: alignment,
      decoration: decoration,
      onTap: onTap,
      onLongPress: onLongPress,
      loadingState: loadingState,
    );
  }

  /// Build a button that contains a [HarbrLoader].
  factory HarbrButton.loader({
    EdgeInsets margin = HarbrUI.MARGIN_HALF,
    Color color = HarbrColours.accent,
    Color? backgroundColor,
    double height = DEFAULT_HEIGHT,
    Alignment alignment = Alignment.center,
    Decoration? decoration,
    Function? onTap,
    Function? onLongPress,
    HarbrLoadingState? loadingState,
  }) {
    return HarbrButton._(
      child: HarbrLoader(
        useSafeArea: false,
        color: color,
        size: HarbrUI.FONT_SIZE_H3,
      ),
      margin: margin,
      height: height,
      backgroundColor: backgroundColor,
      alignment: alignment,
      decoration: decoration,
      onTap: onTap,
      onLongPress: onLongPress,
      loadingState: loadingState,
    );
  }

  /// Build a button that contains a single, centered [Icon].
  factory HarbrButton.icon({
    required IconData? icon,
    Color color = HarbrColours.accent,
    Color? backgroundColor,
    EdgeInsets margin = HarbrUI.MARGIN_HALF,
    double height = DEFAULT_HEIGHT,
    double iconSize = HarbrUI.ICON_SIZE,
    Alignment alignment = Alignment.center,
    Decoration? decoration,
    Function? onTap,
    Function? onLongPress,
    HarbrLoadingState? loadingState,
  }) {
    return HarbrButton._(
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
      margin: margin,
      height: height,
      backgroundColor: backgroundColor,
      alignment: alignment,
      decoration: decoration,
      onTap: onTap,
      onLongPress: onLongPress,
      loadingState: loadingState,
    );
  }
}
