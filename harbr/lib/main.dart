import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/database.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/system/cache/image/image_cache.dart';
import 'package:harbr/system/cache/memory/memory_store.dart';
import 'package:harbr/system/network/network.dart';
import 'package:harbr/system/recovery_mode/main.dart';
import 'package:harbr/system/window_manager/window_manager.dart';
import 'package:harbr/system/platform.dart';

/// Harbr Entry Point: Bootstrap & Run Application
///
/// Runs app in guarded zone to attempt to capture fatal (crashing) errors
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await bootstrap();
        runApp(const HarbrBIOS());
      } catch (error) {
        runApp(const HarbrRecoveryMode());
      }
    },
    (error, stack) => HarbrLogger().critical(error, stack),
  );
}

/// Bootstrap the core
///
Future<void> bootstrap() async {
  await HarbrDB().initialize();
  HarbrLogger().initialize();
  HarbrTheme().initialize();
  if (HarbrWindowManager.isSupported) await HarbrWindowManager().initialize();
  if (HarbrNetwork.isSupported) HarbrNetwork().initialize();
  if (HarbrImageCache.isSupported) HarbrImageCache().initialize();
  HarbrRouter().initialize();
  await HarbrMemoryStore().initialize();
}

class HarbrBIOS extends StatelessWidget {
  const HarbrBIOS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = HarbrTheme();
    final router = HarbrRouter.router;

    return HarbrState.providers(
      child: DevicePreview(
        enabled: kDebugMode && HarbrPlatform.isDesktop,
        builder: (context) => EasyLocalization(
          supportedLocales: [Locale('en')],
          path: 'assets/localization',
          fallbackLocale: Locale('en'),
          startLocale: Locale('en'),
          useFallbackTranslations: true,
          child: HarbrBox.harbr.listenableBuilder(
            selectItems: [
              HarbrDatabase.THEME_AMOLED,
              HarbrDatabase.THEME_AMOLED_BORDER,
            ],
            builder: (context, _) {
              return MaterialApp.router(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: DevicePreview.appBuilder,
                darkTheme: theme.activeTheme(),
                theme: theme.activeTheme(),
                title: 'Harbr',
                routeInformationProvider: router.routeInformationProvider,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
              );
            },
          ),
        ),
      ),
    );
  }
}
