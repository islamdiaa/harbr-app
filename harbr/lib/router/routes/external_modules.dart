import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/external_modules/routes/external_modules/route.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

enum ExternalModulesRoutes with HarbrRoutesMixin {
  HOME('/external_modules');

  @override
  final String path;

  const ExternalModulesRoutes(this.path);

  @override
  HarbrModule get module => HarbrModule.EXTERNAL_MODULES;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case ExternalModulesRoutes.HOME:
        return route(widget: const ExternalModulesRoute());
    }
  }
}
