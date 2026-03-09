import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

/// Create a [HarbrBottomActionBar] that contains button actions.
///
/// The children are expected to be [HarbrButton]s or children of [HarbrButton].
class HarbrBottomActionBar extends StatelessWidget {
  final EdgeInsets padding;
  final List<Widget>? actions;
  final int actionsPerRow;
  final bool useSafeArea;
  final Color? backgroundColor;

  HarbrBottomActionBar({
    required this.actions,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
    this.actionsPerRow = 2,
    this.useSafeArea = true,
    this.backgroundColor,
    Key? key,
  }) : super(key: key) {
    assert(actions?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: useSafeArea,
        bottom: useSafeArea,
        left: useSafeArea,
        right: useSafeArea,
        child: Padding(
          child: HarbrButtonContainer(
            children: actions!,
            padding: EdgeInsets.zero,
            buttonsPerRow: actionsPerRow,
          ),
          padding: padding,
        ),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
