// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpcomingTask _$UpcomingTaskFromJson(Map<String, dynamic> json) =>
    _UpcomingTask(
      id: json['id'] as String,
      dayLabel: json['dayLabel'] as String,
      dateLabel: json['dateLabel'] as String,
      areaName: json['areaName'] as String,
      assignedUser: json['assignedUser'] as String,
      completedItems: (json['completedItems'] as num?)?.toInt() ?? 0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UpcomingTaskToJson(_UpcomingTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayLabel': instance.dayLabel,
      'dateLabel': instance.dateLabel,
      'areaName': instance.areaName,
      'assignedUser': instance.assignedUser,
      'completedItems': instance.completedItems,
      'totalItems': instance.totalItems,
    };
