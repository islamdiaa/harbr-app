import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrBanner extends StatelessWidget {
  // An arbitrarily large number of max lines
  static const _MAX_LINES = 5000000;
  final String headerText;
  final String? bodyText;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Color headerColor;
  final Color bodyColor;
  final Function? dismissCallback;
  final List<HarbrButton>? buttons;

  const HarbrBanner({
    Key? key,
    this.dismissCallback,
    required this.headerText,
    this.bodyText,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = HarbrColours.accent,
    this.backgroundColor,
    this.headerColor = Colors.white,
    this.bodyColor = HarbrColours.grey,
    this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: HarbrUI.MARGIN_H_DEFAULT_V_HALF.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: HarbrUI.MARGIN_H_DEFAULT_V_HALF,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    child: Icon(
                      icon,
                      size: 20.0,
                      color: iconColor,
                    ),
                    padding: EdgeInsets.only(
                        right: HarbrUI.MARGIN_DEFAULT.right - 2.0),
                  ),
                  Expanded(
                    child: HarbrText.title(
                      text: headerText,
                      color: headerColor,
                      maxLines: _MAX_LINES,
                      softWrap: true,
                    ),
                  ),
                  if (dismissCallback != null)
                    InkWell(
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20.0,
                        color: HarbrColours.accent,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      onTap: dismissCallback as void Function()?,
                    ),
                ],
              ),
            ),
            if (bodyText?.isNotEmpty ?? false)
              Padding(
                padding: HarbrUI.MARGIN_H_DEFAULT_V_HALF.copyWith(top: 0),
                child: HarbrText.subtitle(
                  text: bodyText.toString(),
                  color: bodyColor,
                  softWrap: true,
                  maxLines: _MAX_LINES,
                ),
              ),
            if (buttons?.isNotEmpty ?? false)
              HarbrButtonContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: HarbrUI.MARGIN_H_DEFAULT_V_HALF.left / 2),
                children: buttons!,
              ),
          ],
        ),
      ),
      color: backgroundColor,
    );
  }
}
