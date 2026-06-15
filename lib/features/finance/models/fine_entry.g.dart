// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fine_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FineEntry _$FineEntryFromJson(Map<String, dynamic> json) => _FineEntry(
  id: json['id'] as String,
  memberName: json['memberName'] as String,
  reason: json['reason'] as String,
  amount: (json['amount'] as num).toInt(),
  completionPercentage: (json['completionPercentage'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  status: $enumDecode(_$FineStatusEnumMap, json['status']),
);

Map<String, dynamic> _$FineEntryToJson(_FineEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberName': instance.memberName,
      'reason': instance.reason,
      'amount': instance.amount,
      'completionPercentage': instance.completionPercentage,
      'date': instance.date.toIso8601String(),
      'status': _$FineStatusEnumMap[instance.status]!,
    };

const _$FineStatusEnumMap = {
  FineStatus.unpaid: 'unpaid',
  FineStatus.paid: 'paid',
};
