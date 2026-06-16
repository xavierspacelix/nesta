import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_entry.freezed.dart';
part 'schedule_entry.g.dart';

@freezed
abstract class ScheduleEntry with _$ScheduleEntry {
  const factory ScheduleEntry({
    required String id,
    required DateTime date,
    required String roomName,
    required String assignedUser,
    required String assignedTo,
    required ScheduleStatus status,
  }) = _ScheduleEntry;

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEntryFromJson(json);
}

enum ScheduleStatus { pending, completed, missed }
