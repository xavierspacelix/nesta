// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwapRequest _$SwapRequestFromJson(Map<String, dynamic> json) => _SwapRequest(
  id: json['id'] as String,
  requesterName: json['requesterName'] as String,
  targetMemberName: json['targetMemberName'] as String,
  scheduleDate: DateTime.parse(json['scheduleDate'] as String),
  reason: json['reason'] as String,
  status:
      $enumDecodeNullable(_$SwapStatusEnumMap, json['status']) ??
      SwapStatus.pending,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SwapRequestToJson(_SwapRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterName': instance.requesterName,
      'targetMemberName': instance.targetMemberName,
      'scheduleDate': instance.scheduleDate.toIso8601String(),
      'reason': instance.reason,
      'status': _$SwapStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SwapStatusEnumMap = {
  SwapStatus.pending: 'pending',
  SwapStatus.approved: 'approved',
  SwapStatus.rejected: 'rejected',
};
