import 'package:flutter/material.dart';

import 'package:harbr/database/box.dart';
import 'package:harbr/database/models/deprecated.dart';
import 'package:harbr/database/tables/bios.dart';
import 'package:harbr/database/tables/dashboard.dart';
import 'package:harbr/database/tables/lidarr.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/database/tables/nzbget.dart';
import 'package:harbr/database/tables/radarr.dart';
import 'package:harbr/database/tables/sabnzbd.dart';
import 'package:harbr/database/tables/search.dart';
import 'package:harbr/database/tables/sonarr.dart';
import 'package:harbr/database/tables/readarr.dart';
import 'package:harbr/database/tables/tautulli.dart';
import 'package:harbr/vendor.dart';

enum HarbrTable<T extends HarbrTableMixin> {
  bios<BIOSDatabase>('bios', items: BIOSDatabase.values),
  dashboard<DashboardDatabase>('home', items: DashboardDatabase.values),
  lidarr<LidarrDatabase>('lidarr', items: LidarrDatabase.values),
  harbr<HarbrDatabase>('harbr', items: HarbrDatabase.values),
  nzbget<NZBGetDatabase>('nzbget', items: NZBGetDatabase.values),
  radarr<RadarrDatabase>('radarr', items: RadarrDatabase.values),
  sabnzbd<SABnzbdDatabase>('sabnzbd', items: SABnzbdDatabase.values),
  search<SearchDatabase>('search', items: SearchDatabase.values),
  sonarr<SonarrDatabase>('sonarr', items: SonarrDatabase.values),
  readarr<ReadarrDatabase>('readarr', items: ReadarrDatabase.values),
  tautulli<TautulliDatabase>('tautulli', items: TautulliDatabase.values);

  final String key;
  final List<T> items;

  const HarbrTable(
    this.key, {
    required this.items,
  });

  static void register() {
    for (final table in HarbrTable.values) table.items[0].register();
    registerDeprecatedAdapters();
  }

  T? _itemFromKey(String key) {
    for (final item in items) {
      if (item.key == key) return item;
    }
    return null;
  }

  Map<String, dynamic> export() {
    Map<String, dynamic> results = {};

    for (final item in this.items) {
      final value = item.export();
      if (value != null) results[item.key] = value;
    }

    return results;
  }

  void import(Map<String, dynamic>? table) {
    if (table == null || table.isEmpty) return;
    for (final key in table.keys) {
      final db = _itemFromKey(key);
      db?.import(table[key]);
    }
  }
}

mixin HarbrTableMixin<T> on Enum {
  T get fallback;
  HarbrTable get table;

  HarbrBox get box => HarbrBox.harbr;
  String get key => '${table.key.toUpperCase()}_$name';

  T read() => box.read(key, fallback: fallback);
  void update(T value) => box.update(key, value);

  /// Default is an empty list and does not register any Hive adapters
  void register() {}

  /// The list of items that are not imported or exported by default
  List get blockedFromImportExport => [];

  @mustCallSuper
  dynamic export() {
    if (blockedFromImportExport.contains(this)) return null;
    return read();
  }

  @mustCallSuper
  void import(dynamic value) {
    if (blockedFromImportExport.contains(this) || value == null) return;
    return update(value as T);
  }

  Stream<BoxEvent> watch() {
    return box.watch(this.key);
  }

  ValueListenableBuilder listenableBuilder({
    required Widget Function(BuildContext, Widget?) builder,
    Key? key,
    Widget? child,
  }) {
    return box.listenableBuilder(
      key: key,
      selectItems: [this],
      builder: (context, widget) => builder(context, widget),
      child: child,
    );
  }
}
