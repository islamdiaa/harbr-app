import 'package:flutter/material.dart';
import 'package:harbr/database/tables/bios.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/router/routes/dashboard.dart';
import 'package:harbr/system/bios.dart';
import 'package:harbr/vendor.dart';

enum BIOSRoutes with HarbrRoutesMixin {
  HOME('/');

  @override
  final String path;

  const BIOSRoutes(this.path);

  @override
  HarbrModule? get module => null;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case BIOSRoutes.HOME:
        return redirect(redirect: (context, _) {
          HarbrOS().boot(context);

          final fallback = DashboardRoutes.HOME.path;
          return BIOSDatabase.BOOT_MODULE.read().homeRoute ?? fallback;
        });
    }
  }
}
