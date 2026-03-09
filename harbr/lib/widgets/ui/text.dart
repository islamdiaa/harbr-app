import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrText extends Text {
  /// Create a new [Text] widget.
  const HarbrText({
    required String text,
    Key? key,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextStyle? style,
    TextAlign? textAlign,
  }) : super(
          text,
          key: key,
          maxLines: maxLines == 0 ? null : maxLines,
          overflow: overflow,
          softWrap: softWrap,
          style: style,
          textAlign: textAlign,
        );

  /// Create a [HarbrText] widget with the styling pre-assigned to be a Harbr title.
  factory HarbrText.title({
    Key? key,
    required String text,
    int maxLines = 1,
    bool softWrap = false,
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.fade,
    Color color = Colors.white,
  }) =>
      HarbrText(
        text: text,
        key: key,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          fontSize: HarbrUI.FONT_SIZE_H2,
        ),
      );

  /// Create a [HarbrText] widget with the styling pre-assigned to be a Harbr subtitle.
  factory HarbrText.subtitle({
    Key? key,
    required String text,
    int maxLines = 1,
    bool softWrap = false,
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.fade,
    Color color = HarbrColours.grey,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      HarbrText(
        key: key,
        text: text,
        softWrap: softWrap,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontSize: HarbrUI.FONT_SIZE_H3,
          fontStyle: fontStyle,
        ),
      );
}
