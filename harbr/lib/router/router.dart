import 'package:flutter/material.dart';

import 'package:harbr/system/logger.dart';
import 'package:harbr/widgets/pages/error_route.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

class HarbrRouter {
  static late GoRouter router;
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  void initialize() {
    router = GoRouter(
      navigatorKey: navigator,
      errorBuilder: (_, state) => ErrorRoutePage(exception: state.error),
      initialLocation: HarbrRoutes.initialLocation,
      routes: HarbrRoutes.values.map((r) => r.root.routes).toList(),
    );
  }

  void popSafely() {
    if (router.canPop()) router.pop();
  }

  void popToRootRoute() {
    if (navigator.currentState == null) {
      HarbrLogger().warning('Not observing any navigation navigators, skipping');
      return;
    }
    navigator.currentState!.popUntil((route) => route.isFirst);
  }
}
