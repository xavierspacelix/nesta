import 'package:freezed_annotation/freezed_annotation.dart';

part 'fine_entry.freezed.dart';
part 'fine_entry.g.dart';

@freezed
abstract class FineEntry with _$FineEntry {
  const factory FineEntry({
    required String id,
    required String memberId,
    required String memberName,
    required String reason,
    required int amount,
    required double completionPercentage,
    required DateTime date,
    required FineStatus status,
    String? proofPhoto,
  }) = _FineEntry;
  const FineEntry._();

  factory FineEntry.fromJson(Map<String, dynamic> json) =>
      _$FineEntryFromJson(json);

  String get formattedAmount =>
      'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

enum FineStatus { unpaid, pendingVerification, paid }
