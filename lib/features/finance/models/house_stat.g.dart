// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseStat _$HouseStatFromJson(Map<String, dynamic> json) => _HouseStat(
  completedToday: json['completedToday'] as String,
  activeFines: json['activeFines'] as String,
  monthlyPerformance: json['monthlyPerformance'] as String,
  upcomingBills: json['upcomingBills'] as String,
);

Map<String, dynamic> _$HouseStatToJson(_HouseStat instance) =>
    <String, dynamic>{
      'completedToday': instance.completedToday,
      'activeFines': instance.activeFines,
      'monthlyPerformance': instance.monthlyPerformance,
      'upcomingBills': instance.upcomingBills,
    };
