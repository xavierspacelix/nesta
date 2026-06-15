// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskDetail _$TaskDetailFromJson(Map<String, dynamic> json) => _TaskDetail(
  id: json['id'] as String,
  roomName: json['roomName'] as String,
  assignedUser: json['assignedUser'] as String,
  date: DateTime.parse(json['date'] as String),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  checklist:
      (json['checklist'] as List<dynamic>?)
          ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  beforePhoto: json['beforePhoto'] as String?,
  afterPhoto: json['afterPhoto'] as String?,
);

Map<String, dynamic> _$TaskDetailToJson(_TaskDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomName': instance.roomName,
      'assignedUser': instance.assignedUser,
      'date': instance.date.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'checklist': instance.checklist,
      'beforePhoto': instance.beforePhoto,
      'afterPhoto': instance.afterPhoto,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
  TaskStatus.missed: 'missed',
};
