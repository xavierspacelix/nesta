// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentRecord _$RentRecordFromJson(Map<String, dynamic> json) => _RentRecord(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  totalRent: (json['totalRent'] as num).toInt(),
  totalWifi: (json['totalWifi'] as num).toInt(),
  payments: (json['payments'] as List<dynamic>)
      .map((e) => MemberPayment.fromJson(e as Map<String, dynamic>))
      .toList(),
  isPaid: json['isPaid'] as bool,
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  bankName: json['bankName'] as String?,
  bankAccountNumber: json['bankAccountNumber'] as String?,
);

Map<String, dynamic> _$RentRecordToJson(_RentRecord instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'totalRent': instance.totalRent,
      'totalWifi': instance.totalWifi,
      'payments': instance.payments,
      'isPaid': instance.isPaid,
      'paidAt': instance.paidAt?.toIso8601String(),
      'bankName': instance.bankName,
      'bankAccountNumber': instance.bankAccountNumber,
    };

_MemberPayment _$MemberPaymentFromJson(Map<String, dynamic> json) =>
    _MemberPayment(
      memberName: json['memberName'] as String,
      isPaid: json['isPaid'] as bool,
      proofPhoto: json['proofPhoto'] as String?,
    );

Map<String, dynamic> _$MemberPaymentToJson(_MemberPayment instance) =>
    <String, dynamic>{
      'memberName': instance.memberName,
      'isPaid': instance.isPaid,
      'proofPhoto': instance.proofPhoto,
    };
