import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrDivider extends Divider {
  HarbrDivider({
    Key? key,
  }) : super(
          key: key,
          thickness: 1.0,
          color: HarbrColours.accent.dimmed(),
          indent: HarbrUI.DEFAULT_MARGIN_SIZE * 5,
          endIndent: HarbrUI.DEFAULT_MARGIN_SIZE * 5,
        );
}
