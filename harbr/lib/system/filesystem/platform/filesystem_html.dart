// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:harbr/system/filesystem/file.dart';
import 'package:harbr/system/filesystem/filesystem.dart';
import 'package:harbr/system/logger.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

bool isPlatformSupported() => true;
HarbrFileSystem getFileSystem() {
  if (isPlatformSupported()) return _Web();
  throw UnsupportedError('HarbrFileSystem unsupported');
}

class _Web implements HarbrFileSystem {
  @override
  Future<void> nuke() async {}

  @override
  Future<bool> save(BuildContext context, String name, List<int> data) async {
    try {
      final blob = Blob([utf8.decode(data)]);
      final anchor = AnchorElement(href: Url.createObjectUrlFromBlob(blob));
      anchor.setAttribute('download', name);
      anchor.click();
      return true;
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
