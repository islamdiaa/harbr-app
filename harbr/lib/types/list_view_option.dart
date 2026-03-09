import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

part 'list_view_option.g.dart';

const _BLOCK_VIEW = 'BLOCK_VIEW';
const _GRID_VIEW = 'GRID_VIEW';

@HiveType(typeId: 29, adapterName: 'HarbrListViewOptionAdapter')
enum HarbrListViewOption {
  @HiveField(0)
  BLOCK_VIEW(_BLOCK_VIEW),
  @HiveField(1)
  GRID_VIEW(_GRID_VIEW);

  final String key;
  const HarbrListViewOption(this.key);

  static HarbrListViewOption? fromKey(String? key) {
    switch (key) {
      case _BLOCK_VIEW:
        return HarbrListViewOption.BLOCK_VIEW;
      case _GRID_VIEW:
        return HarbrListViewOption.GRID_VIEW;
    }
    return null;
  }
}

extension HarbrListViewOptionExtension on HarbrListViewOption {
  String get readable {
    switch (this) {
      case HarbrListViewOption.BLOCK_VIEW:
        return 'harbr.BlockView'.tr();
      case HarbrListViewOption.GRID_VIEW:
        return 'harbr.GridView'.tr();
    }
  }

  IconData get icon {
    switch (this) {
      case HarbrListViewOption.BLOCK_VIEW:
        return Icons.view_list_rounded;
      case HarbrListViewOption.GRID_VIEW:
        return Icons.grid_view_rounded;
    }
  }
}
