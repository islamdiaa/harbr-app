import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';

bool isPlatformSupported() => false;
HarbrWakeOnLAN getWakeOnLAN() =>
    throw UnsupportedError('HarbrWakeOnLAN unsupported');
