import 'package:harbr/database/table.dart';

enum SearchDatabase<T> with HarbrTableMixin<T> {
  HIDE_XXX<bool>(false),
  SHOW_LINKS<bool>(true);

  @override
  HarbrTable get table => HarbrTable.search;

  @override
  final T fallback;

  const SearchDatabase(this.fallback);
}
