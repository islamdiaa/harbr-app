// ignore: always_use_package_imports
import '../window_manager.dart';

bool isPlatformSupported() => false;
HarbrWindowManager getWindowManager() =>
    throw UnsupportedError('HarbrWindowManager unsupported');
