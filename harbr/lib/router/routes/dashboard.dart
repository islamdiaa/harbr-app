import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/route.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/vendor.dart';

enum DashboardRoutes with HarbrRoutesMixin {
  HOME('/dashboard');

  @override
  final String path;

  const DashboardRoutes(this.path);

  @override
  HarbrModule get module => HarbrModule.DASHBOARD;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case DashboardRoutes.HOME:
        return route(widget: const DashboardRoute());
    }
  }
}
