import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nesta/core/services/logger.dart';
import 'package:nesta/core/providers/progress_provider.dart';
import '../../activity/providers/activity_provider.dart';
import '../models/task_detail.dart';
import '../repositories/task_detail_repository.dart';
import '../repositories/supabase_task_detail_repository.dart';

final taskDetailRepositoryProvider = Provider<ITaskDetailRepository>((ref) {
  return SupabaseTaskDetailRepository(Supabase.instance.client);
});

final taskDetailProvider = AsyncNotifierProvider.family<TaskDetailNotifier, TaskDetail, String>(
  () => TaskDetailNotifier(),
);

class TaskDetailNotifier extends FamilyAsyncNotifier<TaskDetail, String> {
  @override
  Future<TaskDetail> build(String arg) async {
    final repository = ref.watch(taskDetailRepositoryProvider);
    return repository.getTaskDetail(arg);
  }

  Future<void> toggleChecklist(String itemId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final item = current.checklist.firstWhere((i) => i.id == itemId);
    final newStatus = !item.isCompleted;
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final repository = ref.read(taskDetailRepositoryProvider);
      await repository.updateChecklistProgress(
        assignmentId: arg,
        checklistItemId: itemId,
        isCompleted: newStatus,
        userId: userId,
      );

      final updatedList = current.checklist.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isCompleted: newStatus);
        }
        return item;
      }).toList();
      state = AsyncData(current.copyWith(checklist: updatedList));

      ref.read(checklistProgressChangedProvider.notifier).state++;

      final allDone = updatedList.every((i) => i.isCompleted);
      if (allDone) {
        final profile = await client
            .from('profiles')
            .select('house_id')
            .eq('id', userId)
            .maybeSingle();
        final houseId = profile?['house_id'] as String?;
        if (houseId != null) {
          final activityRepo = ref.read(activityRepositoryProvider);
          await activityRepo.createActivity(
            houseId: houseId,
            userId: userId,
            description: 'Menyelesaikan piket ${current.roomName}',
            category: 'chore',
          );
        }
      }
    } catch (e) {
      Log.e('TaskDetailNotifier', 'toggleChecklist failed', e);
    }
  }

  Future<void> uploadEvidence(String photoUrl, String type) async {
    final current = state.valueOrNull;
    if (current == null) return;
    try {
      final repository = ref.read(taskDetailRepositoryProvider);
      await repository.uploadEvidence(arg, type, photoUrl);
      if (type == 'before') {
        state = AsyncData(current.copyWith(beforePhoto: photoUrl));
      } else {
        state = AsyncData(current.copyWith(afterPhoto: photoUrl));
      }
      ref.invalidateSelf();
    } catch (e) {
      Log.e('TaskDetailNotifier', 'uploadEvidence failed', e);
    }
  }
}
