import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_detail.dart';
import '../models/checklist_progress.dart' as cp;
import 'task_detail_repository.dart';

class SupabaseTaskDetailRepository implements ITaskDetailRepository {
  final SupabaseClient _client;

  SupabaseTaskDetailRepository(this._client);

  @override
  Future<TaskDetail> getTaskDetail(String taskId) async {
    try {
      final response = await _client
          .from('assignments')
          .select('''
            id, assigned_date, status, completed_at,
            rooms(name),
            profiles(name, nickname),
            task_evidence(photo_url, type),
            assignment_checklist_progress(
              id, is_completed, updated_by, updated_at,
              checklist_items(id, title)
            )
          ''')
          .eq('id', taskId)
          .single();

      final roomName = (response['rooms'] as Map)['name'] as String;
      final profile = response['profiles'] as Map;
      final userName = (profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first;
      final statusStr = response['status'] as String;

      TaskStatus status;
      switch (statusStr) {
        case 'in_progress':
          status = TaskStatus.inProgress;
          break;
        case 'completed':
          status = TaskStatus.completed;
          break;
        case 'missed':
          status = TaskStatus.missed;
          break;
        default:
          status = TaskStatus.pending;
      }

      final checklistData = response['assignment_checklist_progress'] as List<dynamic>? ?? [];
      final checklist = checklistData.map((item) {
        final checklistItem = item['checklist_items'] as Map;
        return cp.ChecklistItem(
          id: checklistItem['id'] as String,
          name: checklistItem['title'] as String,
          isCompleted: item['is_completed'] as bool? ?? false,
          progressId: item['id'] as String?,
        );
      }).toList();

      final evidenceData = response['task_evidence'] as List<dynamic>? ?? [];
      String? beforePhoto;
      String? afterPhoto;
      for (final ev in evidenceData) {
        final type = ev['type'] as String;
        final url = ev['photo_url'] as String?;
        if (type == 'before' && beforePhoto == null) {
          beforePhoto = url;
        } else if (type == 'after' && afterPhoto == null) {
          afterPhoto = url;
        }
      }

      return TaskDetail(
        id: taskId,
        roomName: roomName,
        assignedUser: userName,
        date: DateTime.parse(response['assigned_date'] as String),
        status: status,
        checklist: checklist,
        beforePhoto: beforePhoto,
        afterPhoto: afterPhoto,
      );
    } catch (e) {
      Log.e('TaskDetailRepo', 'getTaskDetail failed', e);
      rethrow;
    }
  }

  @override
  Future<void> updateChecklistProgress({
    required String assignmentId,
    required String checklistItemId,
    required bool isCompleted,
    required String userId,
  }) async {
    try {
      await _client
          .from('assignment_checklist_progress')
          .update({
            'is_completed': isCompleted,
            'updated_by': userId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('assignment_id', assignmentId)
          .eq('checklist_item_id', checklistItemId);
    } catch (e) {
      Log.e('TaskDetailRepo', 'updateChecklistProgress failed', e);
      rethrow;
    }
  }
}
