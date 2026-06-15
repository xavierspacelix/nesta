// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskVerification _$TaskVerificationFromJson(Map<String, dynamic> json) =>
    _TaskVerification(
      id: json['id'] as String,
      roomName: json['roomName'] as String,
      assignedUser: json['assignedUser'] as String,
      assignedDate: DateTime.parse(json['assignedDate'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      completedItems: (json['completedItems'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      beforePhoto: json['beforePhoto'] as String?,
      afterPhoto: json['afterPhoto'] as String?,
      status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$TaskVerificationToJson(_TaskVerification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomName': instance.roomName,
      'assignedUser': instance.assignedUser,
      'assignedDate': instance.assignedDate.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'completionPercentage': instance.completionPercentage,
      'completedItems': instance.completedItems,
      'totalItems': instance.totalItems,
      'beforePhoto': instance.beforePhoto,
      'afterPhoto': instance.afterPhoto,
      'status': _$VerificationStatusEnumMap[instance.status]!,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.completed: 'completed',
  VerificationStatus.late: 'late',
  VerificationStatus.missed: 'missed',
};
