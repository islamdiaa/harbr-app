import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrLink {
  @JsonKey(name: 'url')
  String? url;

  @JsonKey(name: 'name')
  String? name;

  ReadarrLink({
    this.url,
    this.name,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrLink.fromJson(Map<String, dynamic> json) =>
      _$ReadarrLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrLinkToJson(this);
}
