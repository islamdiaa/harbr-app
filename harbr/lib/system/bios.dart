import 'package:flutter/material.dart';

import 'package:harbr/system/quick_actions/quick_actions.dart';

class HarbrOS {
  Future<void> boot(BuildContext context) async {
    if (HarbrQuickActions.isSupported) HarbrQuickActions().initialize();
  }
}
