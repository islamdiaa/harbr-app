import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrReorderableListViewDragger extends StatelessWidget {
  final int index;

  const HarbrReorderableListViewDragger({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: const HarbrIconButton(
            icon: Icons.menu_rounded,
            mouseCursor: SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }
}
