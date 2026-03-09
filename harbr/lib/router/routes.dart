import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/bios.dart';
import 'package:harbr/router/routes/dashboard.dart';
import 'package:harbr/router/routes/external_modules.dart';
import 'package:harbr/router/routes/lidarr.dart';
import 'package:harbr/router/routes/nzbget.dart';
import 'package:harbr/router/routes/radarr.dart';
import 'package:harbr/router/routes/sabnzbd.dart';
import 'package:harbr/router/routes/search.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/router/routes/readarr.dart';
import 'package:harbr/router/routes/sonarr.dart';
import 'package:harbr/router/routes/tautulli.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/pages/not_enabled.dart';

enum HarbrRoutes {
  bios('bios', root: BIOSRoutes.HOME),
  dashboard('dashboard', root: DashboardRoutes.HOME),
  externalModules('external_modules', root: ExternalModulesRoutes.HOME),
  lidarr('lidarr', root: LidarrRoutes.HOME),
  nzbget('nzbget', root: NZBGetRoutes.HOME),
  radarr('radarr', root: RadarrRoutes.HOME),
  sabnzbd('sabnzbd', root: SABnzbdRoutes.HOME),
  search('search', root: SearchRoutes.HOME),
  settings('settings', root: SettingsRoutes.HOME),
  readarr('readarr', root: ReadarrRoutes.HOME),
  sonarr('sonarr', root: SonarrRoutes.HOME),
  tautulli('tautulli', root: TautulliRoutes.HOME);

  final String key;
  final HarbrRoutesMixin root;

  const HarbrRoutes(
    this.key, {
    required this.root,
  });

  static String get initialLocation => BIOSRoutes.HOME.path;
}

mixin HarbrRoutesMixin on Enum {
  String get _routeName => '${this.module?.key ?? 'unknown'}:$name';

  String get path;
  HarbrModule? get module;

  GoRoute get routes;
  List<GoRoute> get subroutes => const <GoRoute>[];

  bool isModuleEnabled(BuildContext context);

  GoRoute route({
    Widget? widget,
    Widget Function(BuildContext, GoRouterState)? builder,
  }) {
    assert(!(widget == null && builder == null));
    return GoRoute(
      path: path,
      name: _routeName,
      routes: subroutes,
      builder: (context, state) {
        if (isModuleEnabled(context)) {
          return builder?.call(context, state) ?? widget!;
        }
        return NotEnabledPage(module: module?.title ?? 'Harbr');
      },
    );
  }

  GoRoute redirect({
    required GoRouterRedirect redirect,
  }) {
    return GoRoute(
      path: path,
      name: _routeName,
      redirect: redirect,
    );
  }

  void go({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    bool buildTree = false,
  }) {
    if (buildTree) {
      return HarbrRouter.router.goNamed(
        _routeName,
        extra: extra,
        pathParameters: params,
        queryParameters: queryParams,
      );
    }
    HarbrRouter.router.pushNamed(
      _routeName,
      extra: extra,
      pathParameters: params,
      queryParameters: queryParams,
    );
  }
}
