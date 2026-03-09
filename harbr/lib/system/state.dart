import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:harbr/modules/dashboard/core/state.dart';
import 'package:harbr/modules/lidarr/core/state.dart';
import 'package:harbr/modules/radarr/core/state.dart';
import 'package:harbr/modules/search/core/state.dart';
import 'package:harbr/modules/settings/core/state.dart';
import 'package:harbr/modules/sonarr/core/state.dart';
import 'package:harbr/modules/sabnzbd/core/state.dart';
import 'package:harbr/modules/nzbget/core/state.dart';
import 'package:harbr/modules/readarr/core/state.dart';
import 'package:harbr/modules/tautulli/core/state.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/router/router.dart';

class HarbrState {
  HarbrState._();

  static BuildContext get context => HarbrRouter.navigator.currentContext!;

  /// Calls `.reset()` on all states which extend [HarbrModuleState].
  static void reset([BuildContext? context]) {
    final ctx = context ?? HarbrState.context;
    HarbrModule.values.forEach((module) => module.state(ctx)?.reset());
  }

  static MultiProvider providers({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => SearchState()),
        ChangeNotifierProvider(create: (_) => LidarrState()),
        ChangeNotifierProvider(create: (_) => RadarrState()),
        ChangeNotifierProvider(create: (_) => SonarrState()),
        ChangeNotifierProvider(create: (_) => NZBGetState()),
        ChangeNotifierProvider(create: (_) => SABnzbdState()),
        ChangeNotifierProvider(create: (_) => ReadarrState()),
        ChangeNotifierProvider(create: (_) => TautulliState()),
      ],
      child: child,
    );
  }
}

abstract class HarbrModuleState extends ChangeNotifier {
  /// Reset the state back to the default
  void reset();
}
