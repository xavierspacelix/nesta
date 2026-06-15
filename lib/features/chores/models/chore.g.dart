// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chore _$ChoreFromJson(Map<String, dynamic> json) => _Chore(
  id: json['id'] as String,
  title: json['title'] as String,
  completedTasks: (json['completedTasks'] as num).toInt(),
  totalTasks: (json['totalTasks'] as num).toInt(),
  isStarted: json['isStarted'] as bool,
);

Map<String, dynamic> _$ChoreToJson(_Chore instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'completedTasks': instance.completedTasks,
  'totalTasks': instance.totalTasks,
  'isStarted': instance.isStarted,
};
