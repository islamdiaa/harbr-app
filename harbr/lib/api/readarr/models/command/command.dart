import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:harbr/api/readarr/utilities.dart';

part 'command.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ReadarrCommand {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'commandName')
  String? commandName;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'body')
  Map<String, dynamic>? body;

  @JsonKey(name: 'priority')
  String? priority;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(
    name: 'queued',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? queued;

  @JsonKey(
    name: 'started',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? started;

  @JsonKey(
    name: 'ended',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? ended;

  @JsonKey(name: 'trigger')
  String? trigger;

  @JsonKey(
    name: 'stateChangeTime',
    toJson: ReadarrUtilities.dateTimeToJson,
    fromJson: ReadarrUtilities.dateTimeFromJson,
  )
  DateTime? stateChangeTime;

  ReadarrCommand({
    this.id,
    this.name,
    this.commandName,
    this.message,
    this.body,
    this.priority,
    this.status,
    this.queued,
    this.started,
    this.ended,
    this.trigger,
    this.stateChangeTime,
  });

  @override
  String toString() => json.encode(this.toJson());

  factory ReadarrCommand.fromJson(Map<String, dynamic> json) =>
      _$ReadarrCommandFromJson(json);

  Map<String, dynamic> toJson() => _$ReadarrCommandToJson(this);
}
