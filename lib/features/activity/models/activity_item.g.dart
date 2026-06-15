// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) =>
    _ActivityItem(
      id: json['id'] as String,
      description: json['description'] as String,
      timeAgo: json['timeAgo'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ActivityItemToJson(_ActivityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'timeAgo': instance.timeAgo,
      'type': instance.type,
    };
