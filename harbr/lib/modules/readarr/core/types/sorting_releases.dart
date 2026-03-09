import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

part 'sorting_releases.g.dart';

@HiveType(typeId: 33, adapterName: 'ReadarrReleasesSortingAdapter')
enum ReadarrReleasesSorting {
  @HiveField(0)
  AGE,
  @HiveField(1)
  ALPHABETICAL,
  @HiveField(2)
  SEEDERS,
  @HiveField(3)
  SIZE,
  @HiveField(4)
  TYPE,
  @HiveField(5)
  WEIGHT,
}

extension ReadarrReleasesSortingExtension on ReadarrReleasesSorting {
  String get key {
    switch (this) {
      case ReadarrReleasesSorting.AGE:
        return 'age';
      case ReadarrReleasesSorting.ALPHABETICAL:
        return 'abc';
      case ReadarrReleasesSorting.SEEDERS:
        return 'seeders';
      case ReadarrReleasesSorting.WEIGHT:
        return 'weight';
      case ReadarrReleasesSorting.TYPE:
        return 'type';
      case ReadarrReleasesSorting.SIZE:
        return 'size';
    }
  }

  String get readable {
    switch (this) {
      case ReadarrReleasesSorting.AGE:
        return 'readarr.Age'.tr();
      case ReadarrReleasesSorting.ALPHABETICAL:
        return 'readarr.Alphabetical'.tr();
      case ReadarrReleasesSorting.SEEDERS:
        return 'readarr.Seeders'.tr();
      case ReadarrReleasesSorting.WEIGHT:
        return 'readarr.Weight'.tr();
      case ReadarrReleasesSorting.TYPE:
        return 'readarr.Type'.tr();
      case ReadarrReleasesSorting.SIZE:
        return 'readarr.Size'.tr();
    }
  }

  ReadarrReleasesSorting? fromKey(String? key) {
    switch (key) {
      case 'age':
        return ReadarrReleasesSorting.AGE;
      case 'abc':
        return ReadarrReleasesSorting.ALPHABETICAL;
      case 'seeders':
        return ReadarrReleasesSorting.SEEDERS;
      case 'size':
        return ReadarrReleasesSorting.SIZE;
      case 'type':
        return ReadarrReleasesSorting.TYPE;
      case 'weight':
        return ReadarrReleasesSorting.WEIGHT;
      default:
        return null;
    }
  }

  List<ReadarrRelease> sort(List<ReadarrRelease> releases, bool ascending) =>
      _Sorter().byType(releases, this, ascending);
}

class _Sorter {
  List<ReadarrRelease> byType(
    List<ReadarrRelease> releases,
    ReadarrReleasesSorting type,
    bool ascending,
  ) {
    switch (type) {
      case ReadarrReleasesSorting.AGE:
        return _age(releases, ascending);
      case ReadarrReleasesSorting.ALPHABETICAL:
        return _alphabetical(releases, ascending);
      case ReadarrReleasesSorting.SEEDERS:
        return _seeders(releases, ascending);
      case ReadarrReleasesSorting.WEIGHT:
        return _weight(releases, ascending);
      case ReadarrReleasesSorting.TYPE:
        return _type(releases, ascending);
      case ReadarrReleasesSorting.SIZE:
        return _size(releases, ascending);
    }
  }

  List<ReadarrRelease> _alphabetical(
      List<ReadarrRelease> releases, bool ascending) {
    ascending
        ? releases.sort(
            (a, b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()))
        : releases.sort(
            (a, b) => b.title!.toLowerCase().compareTo(a.title!.toLowerCase()));
    return releases;
  }

  List<ReadarrRelease> _age(List<ReadarrRelease> releases, bool ascending) {
    ascending
        ? releases.sort((a, b) => (a.ageHours ?? 0).compareTo(b.ageHours ?? 0))
        : releases
            .sort((a, b) => (b.ageHours ?? 0).compareTo(a.ageHours ?? 0));
    return releases;
  }

  List<ReadarrRelease> _seeders(List<ReadarrRelease> releases, bool ascending) {
    List<ReadarrRelease> _torrent = _weight(
        releases
            .where((release) => release.protocol == 'torrent')
            .toList(),
        true);
    List<ReadarrRelease> _usenet = _weight(
        releases
            .where((release) => release.protocol == 'usenet')
            .toList(),
        true);
    ascending
        ? _torrent
            .sort((a, b) => (a.seeders ?? -1).compareTo((b.seeders ?? -1)))
        : _torrent
            .sort((a, b) => (b.seeders ?? -1).compareTo((a.seeders ?? -1)));
    return [..._torrent, ..._usenet];
  }

  List<ReadarrRelease> _weight(List<ReadarrRelease> releases, bool ascending) {
    ascending
        ? releases.sort((a, b) =>
            (a.releaseWeight ?? -1).compareTo((b.releaseWeight ?? -1)))
        : releases.sort((a, b) =>
            (b.releaseWeight ?? -1).compareTo((a.releaseWeight ?? -1)));
    return releases;
  }

  List<ReadarrRelease> _type(List<ReadarrRelease> releases, bool ascending) {
    List<ReadarrRelease> _torrent = _weight(
        releases
            .where((release) => release.protocol == 'torrent')
            .toList(),
        true);
    List<ReadarrRelease> _usenet = _weight(
        releases
            .where((release) => release.protocol == 'usenet')
            .toList(),
        true);
    return ascending ? [..._torrent, ..._usenet] : [..._usenet, ..._torrent];
  }

  List<ReadarrRelease> _size(List<ReadarrRelease> releases, bool ascending) {
    ascending
        ? releases.sort((a, b) => (a.size ?? -1).compareTo((b.size ?? -1)))
        : releases.sort((a, b) => (b.size ?? -1).compareTo((a.size ?? -1)));
    return releases;
  }
}
