// ignore: always_use_package_imports
import '../filesystem.dart';

bool isPlatformSupported() => false;
HarbrFileSystem getFileSystem() =>
    throw UnsupportedError('HarbrFileSystem unsupported');
