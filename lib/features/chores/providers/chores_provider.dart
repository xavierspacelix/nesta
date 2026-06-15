import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nesta/core/providers/progress_provider.dart';
import '../models/chore.dart';
import '../repositories/chore_repository.dart';
import '../repositories/supabase_chore_repository.dart';

final choreRepositoryProvider = Provider<IChoreRepository>((ref) {
  return SupabaseChoreRepository(Supabase.instance.client);
});

final todayDutyProvider = AsyncNotifierProvider<TodayDutyNotifier, Chore?>(() {
  return TodayDutyNotifier();
});

class TodayDutyNotifier extends AsyncNotifier<Chore?> {
  @override
  Future<Chore?> build() async {
    ref.watch(checklistProgressChangedProvider);
    final repository = ref.watch(choreRepositoryProvider);
    return repository.getTodayChore();
  }
}
