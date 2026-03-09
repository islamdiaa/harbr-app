import 'package:harbr/database/table.dart';

enum SABnzbdDatabase<T> with HarbrTableMixin<T> {
  NAVIGATION_INDEX<int>(0);

  @override
  HarbrTable get table => HarbrTable.sabnzbd;

  @override
  final T fallback;

  const SABnzbdDatabase(this.fallback);
}
