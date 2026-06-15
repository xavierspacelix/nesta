// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      id: json['id'] as String,
      name: json['name'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      progressId: json['progressId'] as String?,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isCompleted': instance.isCompleted,
      'progressId': instance.progressId,
    };
