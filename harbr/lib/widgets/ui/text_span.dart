import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrTextSpan extends TextSpan {
  const HarbrTextSpan.extended({
    required String? text,
  }) : super(
          text: text,
          style: const TextStyle(
            height: HarbrBlock.SUBTITLE_HEIGHT / HarbrUI.FONT_SIZE_H3,
          ),
        );
}
