import 'package:harbr/database/table.dart';

enum NZBGetDatabase<T> with HarbrTableMixin<T> {
  NAVIGATION_INDEX<int>(0);

  @override
  HarbrTable get table => HarbrTable.nzbget;

  @override
  final T fallback;

  const NZBGetDatabase(this.fallback);
}
