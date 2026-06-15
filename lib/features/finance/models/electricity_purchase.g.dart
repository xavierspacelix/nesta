// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ElectricityPurchase _$ElectricityPurchaseFromJson(Map<String, dynamic> json) =>
    _ElectricityPurchase(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      purchasedBy: json['purchasedBy'] as String,
      date: DateTime.parse(json['date'] as String),
      proofPhoto: json['proofPhoto'] as String?,
    );

Map<String, dynamic> _$ElectricityPurchaseToJson(
  _ElectricityPurchase instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'purchasedBy': instance.purchasedBy,
  'date': instance.date.toIso8601String(),
  'proofPhoto': instance.proofPhoto,
};
