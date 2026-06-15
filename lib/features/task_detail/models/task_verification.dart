import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_verification.freezed.dart';
part 'task_verification.g.dart';

@freezed
abstract class TaskVerification with _$TaskVerification {
  const factory TaskVerification({
    required String id,
    required String roomName,
    required String assignedUser,
    required DateTime assignedDate,
    DateTime? completedAt,
    required double completionPercentage,
    required int completedItems,
    required int totalItems,
    String? beforePhoto,
    String? afterPhoto,
    required VerificationStatus status,
  }) = _TaskVerification;

  factory TaskVerification.fromJson(Map<String, dynamic> json) =>
      _$TaskVerificationFromJson(json);
}

enum VerificationStatus { pending, completed, late, missed }
