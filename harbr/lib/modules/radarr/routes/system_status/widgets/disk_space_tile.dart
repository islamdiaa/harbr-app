import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrDiskSpaceTile extends StatelessWidget {
  final RadarrDiskSpace diskSpace;

  const RadarrDiskSpaceTile({
    Key? key,
    required this.diskSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: diskSpace.harbrPath,
      body: [TextSpan(text: diskSpace.harbrSpace)],
      bottom: HarbrLinearPercentIndicator(
        percent: diskSpace.harbrPercentage / 100,
        progressColor: diskSpace.harbrColor,
      ),
      bottomHeight: HarbrLinearPercentIndicator.height,
      trailing: HarbrIconButton(
        text: diskSpace.harbrPercentageString,
        textSize: HarbrUI.FONT_SIZE_H4,
        color: diskSpace.harbrColor,
      ),
    );
  }
}
