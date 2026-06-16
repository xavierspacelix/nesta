import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_schedule.freezed.dart';
part 'water_schedule.g.dart';

@freezed
abstract class WaterSchedule with _$WaterSchedule {
  const factory WaterSchedule({
    required String nextBuyer,
    required String lastBuyer,
    required DateTime? lastPurchaseDate,
    required int daysSinceLastPurchase,
    required List<WaterPurchase> history,
  }) = _WaterSchedule;

  factory WaterSchedule.fromJson(Map<String, dynamic> json) =>
      _$WaterScheduleFromJson(json);
}

@freezed
abstract class WaterPurchase with _$WaterPurchase {
  const factory WaterPurchase({
    required String id,
    required String buyerName,
    required DateTime date,
    String? proofPhoto,
    @Default(false) bool isVerified,
  }) = _WaterPurchase;

  const WaterPurchase._();

  factory WaterPurchase.fromJson(Map<String, dynamic> json) =>
      _$WaterPurchaseFromJson(json);

  bool get isPendingVerification => !isVerified && proofPhoto != null;
}
