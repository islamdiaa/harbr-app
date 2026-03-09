// ignore: always_use_package_imports
import '../image_cache.dart';

bool isPlatformSupported() => false;
HarbrImageCache getImageCache() =>
    throw UnsupportedError('HarbrImageCache unsupported');
