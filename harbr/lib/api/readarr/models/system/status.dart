import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrStatus {
  @JsonKey(name: 'version')
  String? version;

  @JsonKey(name: 'buildTime')
  String? buildTime;

  @JsonKey(name: 'isDebug')
  bool? isDebug;

  @JsonKey(name: 'isProduction')
  bool? isProduction;

  @JsonKey(name: 'isAdmin')
  bool? isAdmin;

  @JsonKey(name: 'isUserInteractive')
  bool? isUserInteractive;

  @JsonKey(name: 'startupPath')
  String? startupPath;

  @JsonKey(name: 'appData')
  String? appData;

  @JsonKey(name: 'osName')
  String? osName;

  @JsonKey(name: 'osVersion')
  String? osVersion;

  @JsonKey(name: 'isNetCore')
  bool? isNetCore;

  @JsonKey(name: 'isLinux')
  bool? isLinux;

  @JsonKey(name: 'isOsx')
  bool? isOsx;

  @JsonKey(name: 'isWindows')
  bool? isWindows;

  @JsonKey(name: 'isDocker')
  bool? isDocker;

  @JsonKey(name: 'branch')
  String? branch;

  @JsonKey(name: 'authentication')
  String? authentication;

  @JsonKey(name: 'sqliteVersion')
  String? sqliteVersion;

  @JsonKey(name: 'urlBase')
  String? urlBase;

  @JsonKey(name: 'runtimeVersion')
  String? runtimeVersion;

  @JsonKey(name: 'runtimeName')
  String? runtimeName;

  ReadarrStatus({
    this.version,
    this.buildTime,
    this.isDebug,
    this.isProduction,
    this.isAdmin,
    this.isUserInteractive,
    this.startupPath,
    this.appData,
    this.osName,
    this.osVersion,
    this.isNetCore,
    this.isLinux,
    this.isOsx,
    this.isWindows,
    this.isDocker,
    this.branch,
    this.authentication,
    this.sqliteVersion,
    this.urlBase,
    this.runtimeVersion,
    this.runtimeName,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrStatus.fromJson(Map<String, dynamic> json) =>
      _$ReadarrStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrStatusToJson(this);
}
