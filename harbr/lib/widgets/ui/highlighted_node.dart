import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrHighlightedNode extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;

  const HarbrHighlightedNode({
    Key? key,
    required this.text,
    this.backgroundColor = HarbrColours.accent,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontSize: HarbrUI.FONT_SIZE_H4,
            color: textColor,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(HarbrUI.BORDER_RADIUS),
      ),
    );
  }
}
