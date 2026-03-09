import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliGraphHelper {
  static const GRAPH_HEIGHT = 225.0;
  static const LEGEND_HEIGHT = 26.0;
  static const DEFAULT_MAX_TITLE_LENGTH = 5;

  BarChartAlignment chartAlignment() => BarChartAlignment.spaceEvenly;

  FlGridData gridData() => const FlGridData(show: false);

  FlBorderData borderData() => FlBorderData(
        show: true,
        border: Border.all(color: HarbrColours.white10),
      );

  FlTitlesData titlesData(
    TautulliGraphData data, {
    int maxTitleLength = DEFAULT_MAX_TITLE_LENGTH,
    bool titleOverFlowShowEllipsis = true,
  }) {
    String _getTitle(double value) {
      return data.categories![value.truncate()]!.length > maxTitleLength + 1
          ? [
              data.categories![value.truncate()]!
                  .substring(
                      0,
                      min(maxTitleLength,
                          data.categories![value.truncate()]!.length))
                  .toUpperCase(),
              if (titleOverFlowShowEllipsis) HarbrUI.TEXT_ELLIPSIS,
            ].join()
          : data.categories![value.truncate()]!.toUpperCase();
    }

    return FlTitlesData(
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize:
              HarbrUI.FONT_SIZE_GRAPH_LEGEND + HarbrUI.DEFAULT_MARGIN_SIZE,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: HarbrUI.DEFAULT_MARGIN_SIZE),
              child: Text(
                _getTitle(value),
                style: const TextStyle(
                  color: HarbrColours.grey,
                  fontSize: HarbrUI.FONT_SIZE_GRAPH_LEGEND,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget createLegend(List<TautulliSeriesData> data) {
    return SizedBox(
      child: Row(
        children: List.generate(
          data.length,
          (index) => Padding(
            child: Row(
              children: [
                Padding(
                  child: Container(
                    height: HarbrUI.FONT_SIZE_GRAPH_LEGEND,
                    width: HarbrUI.FONT_SIZE_GRAPH_LEGEND,
                    decoration: BoxDecoration(
                      color: HarbrColours().byGraphLayer(index),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(right: 6.0),
                ),
                Text(
                  data[index].name!,
                  style: TextStyle(
                    fontSize: HarbrUI.FONT_SIZE_GRAPH_LEGEND,
                    color: HarbrColours().byGraphLayer(index),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
          ),
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      height: LEGEND_HEIGHT,
    );
  }

  Widget loadingContainer(BuildContext context) {
    return HarbrCard(
      context: context,
      child: const SizedBox(
        height: GRAPH_HEIGHT + LEGEND_HEIGHT,
        child: HarbrLoader(),
      ),
    );
  }

  Widget errorContainer(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Container(
        height: GRAPH_HEIGHT + LEGEND_HEIGHT,
        alignment: Alignment.center,
        child: const HarbrIconButton(
          icon: HarbrIcons.ERROR,
          iconSize: HarbrUI.ICON_SIZE * 2,
          color: HarbrColours.red,
        ),
      ),
    );
  }
}
