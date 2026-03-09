import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/database/models/log.dart';
import 'package:harbr/types/exception.dart';
import 'package:harbr/types/log_type.dart';

class HarbrLogger {
  static String get checkLogsMessage => 'harbr.CheckLogsMessage'.tr();

  void initialize() {
    FlutterError.onError = (details) async {
      if (kDebugMode) FlutterError.dumpErrorToConsole(details);
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current,
      );
    };
    _compact();
  }

  Future<void> _compact([int count = 50]) async {
    if (HarbrBox.logs.data.length <= count) return;
    List<HarbrLog> logs = HarbrBox.logs.data.toList();
    logs.sort((a, b) => (b.timestamp).compareTo(a.timestamp));
    logs.skip(count).forEach((log) => log.delete());
  }

  Future<String> export() async {
    final logs = HarbrBox.logs.data.map((log) => log.toJson()).toList();
    final encoder = JsonEncoder.withIndent(' '.repeat(4));
    return encoder.convert(logs);
  }

  Future<void> clear() async => HarbrBox.logs.clear();

  void debug(String message) {
    HarbrLog log = HarbrLog.withMessage(
      type: HarbrLogType.DEBUG,
      message: message,
    );
    HarbrBox.logs.create(log);
  }

  void warning(String message, [String? className, String? methodName]) {
    HarbrLog log = HarbrLog.withMessage(
      type: HarbrLogType.WARNING,
      message: message,
      className: className,
      methodName: methodName,
    );
    HarbrBox.logs.create(log);
  }

  void error(String message, dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print(message);
      print(error);
      print(stackTrace);
    }

    if (error is! NetworkImageLoadException) {
      HarbrLog log = HarbrLog.withError(
        type: HarbrLogType.ERROR,
        message: message,
        error: error,
        stackTrace: stackTrace,
      );
      HarbrBox.logs.create(log);
    }
  }

  void critical(dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      print(error);
      print(stackTrace);
    }

    if (error is! NetworkImageLoadException) {
      HarbrLog log = HarbrLog.withError(
        type: HarbrLogType.CRITICAL,
        message: error?.toString() ?? HarbrUI.TEXT_EMDASH,
        error: error,
        stackTrace: stackTrace,
      );
      HarbrBox.logs.create(log);
    }
  }

  void exception(HarbrException exception, [StackTrace? trace]) {
    switch (exception.type) {
      case HarbrLogType.WARNING:
        warning(exception.toString(), exception.runtimeType.toString());
        break;
      case HarbrLogType.ERROR:
        error(exception.toString(), exception, trace);
        break;
      default:
        break;
    }
  }
}
