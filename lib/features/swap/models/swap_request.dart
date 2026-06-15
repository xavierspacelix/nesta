import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_request.freezed.dart';
part 'swap_request.g.dart';

@freezed
abstract class SwapRequest with _$SwapRequest {
  const factory SwapRequest({
    required String id,
    required String requesterName,
    required String targetMemberName,
    required DateTime scheduleDate,
    required String reason,
    @Default(SwapStatus.pending) SwapStatus status,
    required DateTime createdAt,
  }) = _SwapRequest;

  factory SwapRequest.fromJson(Map<String, dynamic> json) =>
      _$SwapRequestFromJson(json);
}

enum SwapStatus { pending, approved, rejected }
