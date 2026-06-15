// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      roomId: json['roomId'] as String,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'roomId': instance.roomId,
    };
