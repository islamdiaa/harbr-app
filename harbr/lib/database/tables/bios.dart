import 'package:harbr/database/table.dart';
import 'package:harbr/modules.dart';

enum BIOSDatabase<T> with HarbrTableMixin<T> {
  BOOT_MODULE<HarbrModule>(HarbrModule.DASHBOARD),
  FIRST_BOOT<bool>(true);

  @override
  HarbrTable get table => HarbrTable.bios;

  @override
  final T fallback;

  const BIOSDatabase(this.fallback);

  @override
  dynamic export() {
    BIOSDatabase db = this;
    switch (db) {
      case BIOSDatabase.BOOT_MODULE:
        return BIOSDatabase.BOOT_MODULE.read().key;
      default:
        return super.export();
    }
  }

  @override
  void import(dynamic value) {
    BIOSDatabase db = this;
    dynamic result;

    switch (db) {
      case BIOSDatabase.BOOT_MODULE:
        result = HarbrModule.fromKey(value.toString());
        break;
      default:
        result = value;
        break;
    }

    return super.import(result);
  }
}
