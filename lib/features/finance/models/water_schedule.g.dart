// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterSchedule _$WaterScheduleFromJson(Map<String, dynamic> json) =>
    _WaterSchedule(
      nextBuyer: json['nextBuyer'] as String,
      lastBuyer: json['lastBuyer'] as String,
      lastPurchaseDate: json['lastPurchaseDate'] == null
          ? null
          : DateTime.parse(json['lastPurchaseDate'] as String),
      daysSinceLastPurchase: (json['daysSinceLastPurchase'] as num).toInt(),
      history: (json['history'] as List<dynamic>)
          .map((e) => WaterPurchase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WaterScheduleToJson(_WaterSchedule instance) =>
    <String, dynamic>{
      'nextBuyer': instance.nextBuyer,
      'lastBuyer': instance.lastBuyer,
      'lastPurchaseDate': instance.lastPurchaseDate?.toIso8601String(),
      'daysSinceLastPurchase': instance.daysSinceLastPurchase,
      'history': instance.history,
    };

_WaterPurchase _$WaterPurchaseFromJson(Map<String, dynamic> json) =>
    _WaterPurchase(
      buyerName: json['buyerName'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WaterPurchaseToJson(_WaterPurchase instance) =>
    <String, dynamic>{
      'buyerName': instance.buyerName,
      'date': instance.date.toIso8601String(),
    };
