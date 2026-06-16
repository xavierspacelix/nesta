import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_record.freezed.dart';
part 'rent_record.g.dart';

@freezed
abstract class RentRecord with _$RentRecord {
  const factory RentRecord({
    required int year,
    required int month,
    required int totalRent,
    required int totalWifi,
    required List<MemberPayment> payments,
    required bool isPaid,
    int? dueDate,
    DateTime? paidAt,
    String? bankName,
    String? bankAccountNumber,
  }) = _RentRecord;
  const RentRecord._();

  factory RentRecord.fromJson(Map<String, dynamic> json) =>
      _$RentRecordFromJson(json);

  int get perMemberAmount {
    if (payments.isEmpty) return 0;
    return (totalRent + totalWifi) ~/ payments.length;
  }

  int get paidCount => payments.where((p) => p.isPaid).length;
  int get totalCount => payments.length;
}

@freezed
abstract class MemberPayment with _$MemberPayment {
  const factory MemberPayment({
    required String memberId,
    required String memberName,
    required bool isPaid,
    String? proofPhoto,
  }) = _MemberPayment;

  const MemberPayment._();

  factory MemberPayment.fromJson(Map<String, dynamic> json) =>
      _$MemberPaymentFromJson(json);

  bool get isPendingVerification => !isPaid && proofPhoto != null;
}
