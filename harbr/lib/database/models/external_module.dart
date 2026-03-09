import 'package:harbr/core.dart';

part 'external_module.g.dart';

@JsonSerializable()
@HiveType(typeId: 26, adapterName: 'HarbrExternalModuleAdapter')
class HarbrExternalModule extends HiveObject {
  @JsonKey()
  @HiveField(0, defaultValue: '')
  String displayName;

  @JsonKey()
  @HiveField(1, defaultValue: '')
  String host;

  HarbrExternalModule({
    this.displayName = '',
    this.host = '',
  });

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() => _$HarbrExternalModuleToJson(this);

  factory HarbrExternalModule.fromJson(Map<String, dynamic> json) {
    return _$HarbrExternalModuleFromJson(json);
  }

  factory HarbrExternalModule.clone(HarbrExternalModule profile) {
    return HarbrExternalModule.fromJson(profile.toJson());
  }

  factory HarbrExternalModule.get(String key) {
    return HarbrBox.externalModules.read(key)!;
  }
}
