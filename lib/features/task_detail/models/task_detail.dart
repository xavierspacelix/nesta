import 'package:freezed_annotation/freezed_annotation.dart';
import 'checklist_progress.dart';

part 'task_detail.freezed.dart';
part 'task_detail.g.dart';

@freezed
abstract class TaskDetail with _$TaskDetail {
  const factory TaskDetail({
    required String id,
    required String roomName,
    required String assignedUser,
    required DateTime date,
    required TaskStatus status,
    @Default([]) List<ChecklistItem> checklist,
    String? beforePhoto,
    String? afterPhoto,
  }) = _TaskDetail;
  const TaskDetail._();

  factory TaskDetail.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailFromJson(json);

  double get progress {
    if (checklist.isEmpty) return 0;
    final done = checklist.where((c) => c.isCompleted).length;
    return done / checklist.length;
  }

  int get completedCount => checklist.where((c) => c.isCompleted).length;
  int get totalCount => checklist.length;
}

enum TaskStatus { pending, inProgress, completed, missed }
