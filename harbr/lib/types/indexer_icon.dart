import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

part 'indexer_icon.g.dart';

const _GENERIC = 'generic';
const _DOGNZB = 'dognzb';
const _DRUNKENSLUG = 'drunkenslug';
const _NZBFINDER = 'nzbfinder';
const _NZBGEEK = 'nzbgeek';
const _NZBHYDRA = 'nzbhydra';
const _NZBSU = 'nzbsu';

@JsonEnum()
@HiveType(typeId: 22, adapterName: 'HarbrIndexerIconAdapter')
enum HarbrIndexerIcon {
  @JsonValue(_GENERIC)
  @HiveField(0)
  GENERIC(_GENERIC),

  @JsonValue(_DOGNZB)
  @HiveField(1)
  DOGNZB(_DOGNZB),

  @JsonValue(_DRUNKENSLUG)
  @HiveField(2)
  DRUNKENSLUG(_DRUNKENSLUG),

  @JsonValue(_NZBFINDER)
  @HiveField(3)
  NZBFINDER(_NZBFINDER),

  @JsonValue(_NZBGEEK)
  @HiveField(4)
  NZBGEEK(_NZBGEEK),

  @JsonValue(_NZBHYDRA)
  @HiveField(5)
  NZBHYDRA(_NZBHYDRA),

  @JsonValue(_NZBSU)
  @HiveField(6)
  NZBSU(_NZBSU);

  final String key;
  const HarbrIndexerIcon(this.key);

  static HarbrIndexerIcon fromKey(String key) {
    switch (key) {
      case _DOGNZB:
        return HarbrIndexerIcon.DOGNZB;
      case _DRUNKENSLUG:
        return HarbrIndexerIcon.DRUNKENSLUG;
      case _NZBFINDER:
        return HarbrIndexerIcon.NZBFINDER;
      case _NZBGEEK:
        return HarbrIndexerIcon.NZBGEEK;
      case _NZBHYDRA:
        return HarbrIndexerIcon.NZBHYDRA;
      case _NZBSU:
        return HarbrIndexerIcon.NZBSU;
      default:
        return HarbrIndexerIcon.GENERIC;
    }
  }

  String get name {
    switch (this) {
      case HarbrIndexerIcon.GENERIC:
        return 'Generic';
      case HarbrIndexerIcon.DOGNZB:
        return 'DOGnzb';
      case HarbrIndexerIcon.DRUNKENSLUG:
        return 'DrunkenSlug';
      case HarbrIndexerIcon.NZBFINDER:
        return 'NZBFinder';
      case HarbrIndexerIcon.NZBGEEK:
        return 'NZBGeek';
      case HarbrIndexerIcon.NZBHYDRA:
        return 'NZBHydra2';
      case HarbrIndexerIcon.NZBSU:
        return 'NZB.su';
    }
  }

  IconData get icon {
    switch (this) {
      case HarbrIndexerIcon.GENERIC:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.DOGNZB:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.DRUNKENSLUG:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.NZBFINDER:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.NZBGEEK:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.NZBHYDRA:
        return Icons.rss_feed_rounded;
      case HarbrIndexerIcon.NZBSU:
        return Icons.rss_feed_rounded;
    }
  }
}
