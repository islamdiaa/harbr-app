import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/database.dart';
import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/database/table.dart';

class HarbrConfig {
  Future<void> import(BuildContext context, String data) async {
    await HarbrDB().clear();

    try {
      Map<String, dynamic> config = json.decode(data);

      _setProfiles(config[HarbrBox.profiles.key]);
      _setIndexers(config[HarbrBox.indexers.key]);
      _setExternalModules(config[HarbrBox.externalModules.key]);
      for (final table in HarbrTable.values) table.import(config[table.key]);

      if (!HarbrProfile.list.contains(HarbrDatabase.ENABLED_PROFILE.read())) {
        HarbrDatabase.ENABLED_PROFILE.update(HarbrProfile.list[0]);
      }
    } catch (error, stack) {
      await HarbrDB().bootstrap();
      HarbrLogger().error(
        'Failed to import configuration, resetting to default',
        error,
        stack,
      );
    }

    HarbrState.reset(context);
  }

  String export() {
    Map<String, dynamic> config = {};
    config[HarbrBox.externalModules.key] = HarbrBox.externalModules.export();
    config[HarbrBox.indexers.key] = HarbrBox.indexers.export();
    config[HarbrBox.profiles.key] = HarbrBox.profiles.export();
    for (final table in HarbrTable.values) config[table.key] = table.export();

    return json.encode(config);
  }

  void _setProfiles(List? data) {
    if (data == null) return;

    for (final item in data) {
      final content = (item as Map).cast<String, dynamic>();
      final key = content['key'] ?? 'default';
      final obj = HarbrProfile.fromJson(content);
      HarbrBox.profiles.update(key, obj);
    }
  }

  void _setIndexers(List? data) {
    if (data == null) return;

    for (final indexer in data) {
      final obj = HarbrIndexer.fromJson(indexer);
      HarbrBox.indexers.create(obj);
    }
  }

  void _setExternalModules(List? data) {
    if (data == null) return;

    for (final module in data) {
      final obj = HarbrExternalModule.fromJson(module);
      HarbrBox.externalModules.create(obj);
    }
  }
}
