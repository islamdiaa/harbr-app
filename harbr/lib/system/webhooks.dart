import 'package:harbr/core.dart';

abstract class HarbrWebhooks {
  Future<void> handle(Map<dynamic, dynamic> data);

  static String buildUserTokenURL(String token, HarbrModule module) {
    return 'https://notify.harbr.app/v1/${module.key}/user/$token';
  }

  static String buildDeviceTokenURL(String token, HarbrModule module) {
    return 'https://notify.harbr.app/v1/${module.key}/device/$token';
  }
}
