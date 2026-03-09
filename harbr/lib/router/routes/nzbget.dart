import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/nzbget/routes/nzbget.dart';
import 'package:harbr/modules/nzbget/routes/statistics.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

enum NZBGetRoutes with HarbrRoutesMixin {
  HOME('/nzbget'),
  STATISTICS('statistics');

  @override
  final String path;

  const NZBGetRoutes(this.path);

  @override
  HarbrModule get module => HarbrModule.NZBGET;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case NZBGetRoutes.HOME:
        return route(widget: const NZBGetRoute());
      case NZBGetRoutes.STATISTICS:
        return route(widget: const StatisticsRoute());
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case NZBGetRoutes.HOME:
        return [
          NZBGetRoutes.STATISTICS.routes,
        ];
      default:
        return const [];
    }
  }
}
