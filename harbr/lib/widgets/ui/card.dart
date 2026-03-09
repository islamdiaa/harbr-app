import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrCard extends Card {
  HarbrCard({
    Key? key,
    required BuildContext context,
    required Widget child,
    EdgeInsets margin = HarbrUI.MARGIN_H_DEFAULT_V_HALF,
    Color? color,
    Decoration? decoration,
    double? height,
    double? width,
  }) : super(
          key: key,
          child: Container(
            child: child,
            decoration: decoration,
            height: height,
            width: width,
          ),
          margin: margin,
          color: color ?? Theme.of(context).primaryColor,
          shape: HarbrUI.shapeBorder,
          elevation: 0.0,
          clipBehavior: Clip.antiAlias,
        );
}
