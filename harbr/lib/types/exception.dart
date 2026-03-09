import 'package:harbr/types/log_type.dart';

abstract class HarbrException implements Exception {
  HarbrLogType get type;
}

mixin WarningExceptionMixin implements HarbrException {
  @override
  HarbrLogType get type => HarbrLogType.WARNING;
}

mixin ErrorExceptionMixin implements HarbrException {
  @override
  HarbrLogType get type => HarbrLogType.ERROR;
}
