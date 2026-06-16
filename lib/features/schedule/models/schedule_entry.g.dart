// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleEntry _$ScheduleEntryFromJson(Map<String, dynamic> json) =>
    _ScheduleEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      roomName: json['roomName'] as String,
      assignedUser: json['assignedUser'] as String,
      assignedTo: json['assignedTo'] as String,
      status: $enumDecode(_$ScheduleStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ScheduleEntryToJson(_ScheduleEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'roomName': instance.roomName,
      'assignedUser': instance.assignedUser,
      'assignedTo': instance.assignedTo,
      'status': _$ScheduleStatusEnumMap[instance.status]!,
    };

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.pending: 'pending',
  ScheduleStatus.completed: 'completed',
  ScheduleStatus.missed: 'missed',
};
