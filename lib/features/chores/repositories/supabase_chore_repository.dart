import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chore.dart';
import 'chore_repository.dart';

class SupabaseChoreRepository implements IChoreRepository {
  final SupabaseClient _client;

  SupabaseChoreRepository(this._client);

  @override
  Future<Chore?> getTodayChore() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final response = await _client
          .from('assignments')
          .select('''
            id, status,
            rooms(name),
            assignment_checklist_progress(is_completed)
          ''')
          .eq('assigned_to', userId)
          .eq('assigned_date', dateStr)
          .maybeSingle();

      if (response == null) return null;
      return _mapChore(response);
    } catch (e) {
      Log.e('ChoreRepo', 'getTodayChore failed', e);
      rethrow;
    }
  }

  @override
  Future<List<Chore>> getTodayChores() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final response = await _client
          .from('assignments')
          .select('''
            id, status,
            rooms(name),
            assignment_checklist_progress(is_completed)
          ''')
          .eq('assigned_to', userId)
          .eq('assigned_date', dateStr);

      return response.map((json) => _mapChore(json)).toList();
    } catch (e) {
      Log.e('ChoreRepo', 'getTodayChores failed', e);
      rethrow;
    }
  }

  Chore _mapChore(Map<String, dynamic> json) {
    final roomName = json['rooms'] is Map
        ? (json['rooms'] as Map)['name'] as String? ?? 'Unknown'
        : 'Unknown';

    final progressData =
        json['assignment_checklist_progress'] as List<dynamic>? ?? [];
    final totalTasks = progressData.length;
    final completedTasks = progressData
        .where((p) => p['is_completed'] == true)
        .length;

    return Chore(
      id: json['id'] as String,
      title: roomName,
      completedTasks: completedTasks,
      totalTasks: totalTasks,
      isStarted: completedTasks > 0 || json['status'] == 'in_progress',
    );
  }
}
