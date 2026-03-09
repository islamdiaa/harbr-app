import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

@Deprecated("Use HarbrBlock instead")
class HarbrListTile extends Card {
  HarbrListTile({
    Key? key,
    required BuildContext context,
    required Widget title,
    required double height,
    Widget? subtitle,
    Widget? trailing,
    Widget? leading,
    Color? color,
    Decoration? decoration,
    Function? onTap,
    Function? onLongPress,
    bool drawBorder = true,
    EdgeInsets margin = HarbrUI.MARGIN_H_DEFAULT_V_HALF,
  }) : super(
          key: key,
          child: Container(
            height: height,
            child: InkWell(
              child: Row(
                children: [
                  if (leading != null)
                    SizedBox(
                      width: HarbrUI.DEFAULT_MARGIN_SIZE * 4 +
                          HarbrUI.DEFAULT_MARGIN_SIZE / 2,
                      child: leading,
                    ),
                  Expanded(
                    child: Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: title,
                            height: HarbrBlock.TITLE_HEIGHT,
                          ),
                          if (subtitle != null) subtitle,
                        ],
                      ),
                      padding: EdgeInsets.only(
                        top: HarbrUI.DEFAULT_MARGIN_SIZE,
                        bottom: HarbrUI.DEFAULT_MARGIN_SIZE,
                        left: leading != null ? 0 : HarbrUI.DEFAULT_MARGIN_SIZE,
                        right:
                            trailing != null ? 0 : HarbrUI.DEFAULT_MARGIN_SIZE,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
                      ),
                      child: SizedBox(
                        width: HarbrUI.DEFAULT_MARGIN_SIZE * 4,
                        child: trailing,
                      ),
                    ),
                ],
              ),
              borderRadius: BorderRadius.circular(HarbrUI.BORDER_RADIUS),
              onTap: onTap as void Function()?,
              onLongPress: onLongPress as void Function()?,
              mouseCursor: MouseCursor.defer,
            ),
            decoration: decoration,
          ),
          margin: margin,
          elevation: HarbrUI.ELEVATION,
          shape: drawBorder ? HarbrUI.shapeBorder : HarbrShapeBorder(),
          color: color ?? Theme.of(context).primaryColor,
        );
}
