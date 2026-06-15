import 'package:freezed_annotation/freezed_annotation.dart';

part 'house_stat.freezed.dart';
part 'house_stat.g.dart';

@freezed
abstract class HouseStat with _$HouseStat {
  const factory HouseStat({
    required String completedToday,
    required String activeFines,
    required String monthlyPerformance,
    required String upcomingBills,
  }) = _HouseStat;

  factory HouseStat.fromJson(Map<String, dynamic> json) =>
      _$HouseStatFromJson(json);
}
