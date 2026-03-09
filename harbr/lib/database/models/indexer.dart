import 'package:harbr/core.dart';

part 'indexer.g.dart';

@JsonSerializable()
@HiveType(typeId: 1, adapterName: 'HarbrIndexerAdapter')
class HarbrIndexer extends HiveObject {
  @JsonKey()
  @HiveField(0, defaultValue: '')
  String displayName;

  @JsonKey()
  @HiveField(1, defaultValue: '')
  String host;

  @JsonKey(name: 'key')
  @HiveField(2, defaultValue: '')
  String apiKey;

  @JsonKey()
  @HiveField(3, defaultValue: <String, String>{})
  Map<String, String> headers;

  HarbrIndexer._internal({
    required this.displayName,
    required this.host,
    required this.apiKey,
    required this.headers,
  });

  factory HarbrIndexer({
    String? displayName,
    String? host,
    String? apiKey,
    Map<String, String>? headers,
  }) {
    return HarbrIndexer._internal(
      displayName: displayName ?? '',
      host: host ?? '',
      apiKey: apiKey ?? '',
      headers: headers ?? {},
    );
  }

  @override
  String toString() => json.encode(this.toJson());

  Map<String, dynamic> toJson() => _$HarbrIndexerToJson(this);

  factory HarbrIndexer.fromJson(Map<String, dynamic> json) {
    return _$HarbrIndexerFromJson(json);
  }

  factory HarbrIndexer.clone(HarbrIndexer profile) {
    return HarbrIndexer.fromJson(profile.toJson());
  }

  factory HarbrIndexer.get(String key) {
    return HarbrBox.indexers.read(key)!;
  }
}
