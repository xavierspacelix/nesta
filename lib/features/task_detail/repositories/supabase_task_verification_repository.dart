import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_verification.dart';
import 'task_verification_repository.dart';

class SupabaseTaskVerificationRepository implements ITaskVerificationRepository {
  final SupabaseClient _client;

  SupabaseTaskVerificationRepository(this._client);

  @override
  Future<TaskVerification> getVerification(String taskId) async {
    try {
      final response = await _client
          .from('assignments')
          .select('''
            id, assigned_date, status, completed_at,
            rooms(name),
            profiles(name, nickname),
            task_evidence(photo_url, type)
          ''')
          .eq('id', taskId)
          .single();

      final roomName = (response['rooms'] as Map)['name'] as String;
      final profile = response['profiles'] as Map;
      final userName = (profile['nickname'] as String?) ?? (profile['name'] as String? ?? 'Unknown').split(' ').first;
      final statusStr = response['status'] as String;
      final completedAt = response['completed_at'] as String?;
      final assignedDate = DateTime.parse(response['assigned_date'] as String);

      VerificationStatus vStatus;
      switch (statusStr) {
        case 'completed':
          vStatus = VerificationStatus.completed;
          break;
        case 'missed':
          vStatus = VerificationStatus.missed;
          break;
        default:
          vStatus = VerificationStatus.pending;
      }

      // Check if completed but late
      if (statusStr == 'completed' && completedAt != null) {
        final completedDateTime = DateTime.parse(completedAt);
        final dayEnd = DateTime(
          assignedDate.year, assignedDate.month, assignedDate.day, 23, 59, 59,
        );
        if (completedDateTime.isAfter(dayEnd)) {
          vStatus = VerificationStatus.late;
        }
      }

      final evidenceData = response['task_evidence'] as List<dynamic>? ?? [];
      String? beforePhoto;
      String? afterPhoto;
      for (final ev in evidenceData) {
        final type = ev['type'] as String;
        final url = ev['photo_url'] as String?;
        if (type == 'before' && beforePhoto == null) beforePhoto = url;
        if (type == 'after' && afterPhoto == null) afterPhoto = url;
      }

      // Fetch checklist progress for completion stats
      final checklistItems = await _client
          .from('assignment_checklist_progress')
          .select('is_completed')
          .eq('assignment_id', taskId);

      final totalItems = checklistItems.length;
      final completedItems = checklistItems
          .where((item) => item['is_completed'] as bool? ?? false)
          .length;
      final completionPercentage = totalItems > 0 ? completedItems / totalItems : 0.0;

      return TaskVerification(
        id: taskId,
        roomName: roomName,
        assignedUser: userName,
        assignedDate: assignedDate,
        completedAt: completedAt != null ? DateTime.parse(completedAt) : null,
        completionPercentage: completionPercentage,
        completedItems: completedItems,
        totalItems: totalItems,
        beforePhoto: beforePhoto,
        afterPhoto: afterPhoto,
        status: vStatus,
      );
    } catch (e) {
      Log.e('TaskVerifRepo', 'getVerification failed', e);
      rethrow;
    }
  }

  @override
  Future<void> approveTask(String taskId) async {
    try {
      await _client.from('assignments').update({
        'status': 'completed',
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', taskId);
    } catch (e) {
      Log.e('TaskVerifRepo', 'approveTask failed', e);
      rethrow;
    }
  }
}
