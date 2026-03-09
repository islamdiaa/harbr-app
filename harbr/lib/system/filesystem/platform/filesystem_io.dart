import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:harbr/database/database.dart';
import 'package:harbr/vendor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:harbr/widgets/ui.dart';
import 'package:harbr/system/logger.dart';
import 'package:harbr/system/platform.dart';
import 'package:harbr/system/filesystem/file.dart';
import 'package:harbr/system/filesystem/filesystem.dart';

bool isPlatformSupported() {
  return HarbrPlatform.isMobile || HarbrPlatform.isDesktop;
}

HarbrFileSystem getFileSystem() {
  if (HarbrPlatform.isMobile) return _Mobile();
  if (HarbrPlatform.isDesktop) return _Desktop();
  throw UnsupportedError('HarbrFileSystem unsupported');
}

abstract class _Shared implements HarbrFileSystem {
  @override
  Future<void> nuke() async {
    final subpath = HarbrDB().path;
    final appDocDir = await getApplicationDocumentsDirectory();
    final database = Directory('${appDocDir.path}/$subpath');

    if (database.existsSync()) {
      database.deleteSync(recursive: true);
    }
  }
}

class _Desktop extends _Shared {
  @override
  Future<bool> save(BuildContext context, String name, List<int> data) async {
    try {
      String? path = await FilePicker.platform.saveFile(
        fileName: name,
        lockParentWindow: true,
      );
      if (path != null) {
        File file = File(path);
        file.writeAsBytesSync(data);
        return true;
      }
      return false;
    } catch (error, stack) {
      HarbrLogger().error('Failed to save to filesystem', error, stack);
      rethrow;
    }
  }

  @override
  Future<HarbrFile?> read(BuildContext context, List<String> extensions) async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);

      if (result?.files.isNotEmpty ?? false) {
        String? _ext = result!.files[0].extension;
        if (HarbrFileSystem.isValidExtension(extensions, _ext)) {
          return HarbrFile(
            name: result.files[0].name,
            path: result.files[0].path!,
            data: result.files[0].bytes!,
          );
        } else {
          showHarbrErrorSnackBar(
            title: 'harbr.InvalidFileTypeSelected'.tr(),
            message: extensions.map((s) => '.$s').join(', '),
          );
        }
      }

      return null;
    } catch (error, stack) {
      HarbrLogger().error('Failed to read from filesystem', error, stack);
      rethrow;
    }
  }
}

class _Mobile extends _Shared {
  @override
  Future<bool> save(BuildContext context, String name, List<int> data) async {
    try {
      Directory directory = await getTemporaryDirectory();
      String path = '${directory.path}/$name';
      File file = File(path);
      file.writeAsBytesSync(data);

      // Determine share window position
      RenderBox? box = context.findRenderObject() as RenderBox?;
      Rect? rect;
      if (box != null) rect = box.localToGlobal(Offset.zero) & box.size;

      ShareResult result = await Share.shareXFiles(
        [XFile(path)],
        sharePositionOrigin: rect,
      );
      switch (result.status) {
        case ShareResultStatus.success:
          return true;
        case ShareResultStatus.unavailable:
        case ShareResultStatus.dismissed:
          return false;
      }
    } catch (error, stack) {
      HarbrLogger().error('Failed to save to filesystem', error, stack);
      rethrow;
    }
  }

  @override
  Future<HarbrFile?> read(BuildContext context, List<String> extensions) async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);

      if (result?.files.isNotEmpty ?? false) {
        String? _ext = result!.files[0].extension;
        if (HarbrFileSystem.isValidExtension(extensions, _ext)) {
          return HarbrFile(
            name: result.files[0].name,
            path: result.files[0].path!,
            data: result.files[0].bytes!,
          );
        } else {
          showHarbrErrorSnackBar(
            title: 'harbr.InvalidFileTypeSelected'.tr(),
            message: extensions.map((s) => '.$s').join(', '),
          );
        }
      }

      return null;
    } catch (error, stack) {
      HarbrLogger().error('Failed to read from filesystem', error, stack);
      rethrow;
    }
  }
}
