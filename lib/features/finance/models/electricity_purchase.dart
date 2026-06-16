import 'package:freezed_annotation/freezed_annotation.dart';

part 'electricity_purchase.freezed.dart';
part 'electricity_purchase.g.dart';

@freezed
abstract class ElectricityPurchase with _$ElectricityPurchase {
  const factory ElectricityPurchase({
    required String id,
    required int amount,
    required String purchasedBy,
    required DateTime date,
    String? proofPhoto,
    @Default(false) bool isVerified,
  }) = _ElectricityPurchase;
  const ElectricityPurchase._();

  factory ElectricityPurchase.fromJson(Map<String, dynamic> json) =>
      _$ElectricityPurchaseFromJson(json);
}
