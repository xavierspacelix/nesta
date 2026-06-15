import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nesta/core/providers/progress_provider.dart';
import '../models/schedule_entry.dart';
import '../models/upcoming_task.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/supabase_schedule_repository.dart';

final scheduleRepositoryProvider = Provider<IScheduleRepository>((ref) {
  return SupabaseScheduleRepository(Supabase.instance.client);
});

enum ScheduleView { today, weekly, monthly }

final scheduleViewProvider = StateProvider<ScheduleView>((ref) {
  return ScheduleView.weekly;
});

final scheduleProvider = AsyncNotifierProvider<ScheduleNotifier, List<ScheduleEntry>>(() {
  return ScheduleNotifier();
});

final upcomingTasksProvider = FutureProvider<List<UpcomingTask>>((ref) {
  ref.watch(checklistProgressChangedProvider);
  final repository = ref.watch(scheduleRepositoryProvider);
  return repository.getUpcomingTasks();
});

class ScheduleNotifier extends AsyncNotifier<List<ScheduleEntry>> {
  @override
  Future<List<ScheduleEntry>> build() async {
    ref.watch(checklistProgressChangedProvider);
    final view = ref.watch(scheduleViewProvider);
    final repository = ref.watch(scheduleRepositoryProvider);
    switch (view) {
      case ScheduleView.today:
        return repository.getTodaySchedule();
      case ScheduleView.weekly:
        return repository.getWeeklySchedule();
      case ScheduleView.monthly:
        return repository.getMonthlySchedule();
    }
  }
}
