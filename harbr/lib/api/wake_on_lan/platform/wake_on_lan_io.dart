import 'package:wake_on_lan/wake_on_lan.dart';
import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/system/logger.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

bool isPlatformSupported() => true;
HarbrWakeOnLAN getWakeOnLAN() => IO();

class IO implements HarbrWakeOnLAN {
  @override
  Future<void> wake() async {
    HarbrProfile profile = HarbrProfile.current;
    try {
      final ip = IPAddress(profile.wakeOnLANBroadcastAddress);
      final mac = MACAddress(profile.wakeOnLANMACAddress);
      return WakeOnLAN(ip, mac).wake().then((_) {
        showHarbrSuccessSnackBar(
          title: 'wake_on_lan.MagicPacketSent'.tr(),
          message: 'wake_on_lan.MagicPacketSentMessage'.tr(),
        );
      });
    } catch (error, stack) {
      HarbrLogger().error(
        'Failed to send wake on LAN magic packet',
        error,
        stack,
      );
      showHarbrErrorSnackBar(
        title: 'wake_on_lan.MagicPacketFailedToSend'.tr(),
        error: error,
      );
    }
  }
}
