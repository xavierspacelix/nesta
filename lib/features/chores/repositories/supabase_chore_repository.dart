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

      await _ensureRotation(userId, today, dateStr);

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

      final roomName = response['rooms'] is Map
          ? (response['rooms'] as Map)['name'] as String? ?? 'Unknown'
          : 'Unknown';

      final progressData = response['assignment_checklist_progress'] as List<dynamic>? ?? [];
      final totalTasks = progressData.length;
      final completedTasks = progressData.where((p) => p['is_completed'] == true).length;

      return Chore(
        id: response['id'] as String,
        title: roomName,
        completedTasks: completedTasks,
        totalTasks: totalTasks,
        isStarted: completedTasks > 0 || response['status'] == 'in_progress',
      );
    } catch (e) {
      Log.e('ChoreRepo', 'getTodayChore failed', e);
      rethrow;
    }
  }

  Future<void> _ensureRotation(String userId, DateTime today, String dateStr) async {
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', userId)
        .maybeSingle();
    final houseId = profile?['house_id'] as String?;
    if (houseId == null) return;

    final existing = await _client
        .from('assignments')
        .select('id')
        .eq('house_id', houseId)
        .eq('assigned_date', dateStr)
        .maybeSingle();
    if (existing != null) return;

    final members = await _client
        .from('profiles')
        .select('id')
        .eq('house_id', houseId)
        .order('created_at');
    if (members.isEmpty) return;

    final rooms = await _client
        .from('rooms')
        .select('id')
        .eq('house_id', houseId)
        .order('created_at');
    if (rooms.isEmpty) return;

    final house = await _client
        .from('houses')
        .select('created_at')
        .eq('id', houseId)
        .single();
    final houseDate = DateTime.parse(house['created_at'] as String);
    final dayOffset = today.difference(DateTime(houseDate.year, houseDate.month, houseDate.day)).inDays;

    final roomIds = rooms.map((r) => r['id'] as String).toList();
    final allItems = await _client
        .from('checklist_items')
        .select('id, room_id')
        .inFilter('room_id', roomIds);

    final itemsByRoom = <String, List<Map<String, dynamic>>>{};
    for (final item in allItems) {
      final rid = item['room_id'] as String;
      itemsByRoom.putIfAbsent(rid, () => []).add(item);
    }

    final assignments = (rooms as List).asMap().entries.map((e) {
      final memberIndex = (e.key + dayOffset) % members.length;
      return {
        'house_id': houseId,
        'room_id': e.value['id'],
        'assigned_to': members[memberIndex]['id'],
        'assigned_date': dateStr,
        'status': 'pending',
      };
    }).toList();

    await _client.from('assignments').insert(assignments);

    final inserted = await _client
        .from('assignments')
        .select('id, room_id')
        .eq('house_id', houseId)
        .eq('assigned_date', dateStr);

    final progressBatch = <Map<String, dynamic>>[];
    for (final assignment in inserted) {
      final rid = assignment['room_id'] as String;
      final items = itemsByRoom[rid] ?? [];
      for (final item in items) {
        progressBatch.add({
          'assignment_id': assignment['id'],
          'checklist_item_id': item['id'],
        });
      }
    }
    if (progressBatch.isNotEmpty) {
      await _client.from('assignment_checklist_progress').insert(progressBatch);
    }
  }
}
