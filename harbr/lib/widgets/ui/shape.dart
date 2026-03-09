import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrShapeBorder extends RoundedRectangleBorder {
  HarbrShapeBorder({
    bool useBorder = false,
    bool topOnly = false,
  }) : super(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(HarbrUI.BORDER_RADIUS),
            topRight: const Radius.circular(HarbrUI.BORDER_RADIUS),
            bottomLeft: topOnly
                ? Radius.zero
                : const Radius.circular(HarbrUI.BORDER_RADIUS),
            bottomRight: topOnly
                ? Radius.zero
                : const Radius.circular(HarbrUI.BORDER_RADIUS),
          ),
          side: useBorder
              ? const BorderSide(color: HarbrColours.white10)
              : BorderSide.none,
        );
}
