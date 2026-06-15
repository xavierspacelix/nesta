import 'package:freezed_annotation/freezed_annotation.dart';

part 'upcoming_task.freezed.dart';
part 'upcoming_task.g.dart';

@freezed
abstract class UpcomingTask with _$UpcomingTask {
  const factory UpcomingTask({
    required String id,
    required String dayLabel,
    required String dateLabel,
    required String areaName,
    required String assignedUser,
    @Default(0) int completedItems,
    @Default(0) int totalItems,
  }) = _UpcomingTask;

  factory UpcomingTask.fromJson(Map<String, dynamic> json) =>
      _$UpcomingTaskFromJson(json);
}
