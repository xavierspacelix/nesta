import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/schedule_entry.dart';
import '../models/upcoming_task.dart';
import 'schedule_repository.dart';

class SupabaseScheduleRepository implements IScheduleRepository {
  final SupabaseClient _client;

  SupabaseScheduleRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<String?> _getHouseId() async {
    final profile = await _client
        .from('profiles')
        .select('house_id')
        .eq('id', _userId)
        .maybeSingle();
    if (profile == null) return null;
    return profile['house_id'] as String?;
  }

  Future<void> _generateRotations(String houseId, DateTime from, DateTime to) async {
    Log.d('ScheduleRepo', '_generateRotations: $houseId ${_dateStr(from)}–${_dateStr(to)}');

    final rooms = await _client
        .from('rooms')
        .select('id')
        .eq('house_id', houseId)
        .order('created_at');

    final members = await _client
        .from('profiles')
        .select('id')
        .eq('house_id', houseId)
        .eq('status', 'active')
        .order('created_at');

    if (rooms.isEmpty || members.isEmpty) {
      Log.w('ScheduleRepo', 'skip rotation: ${rooms.length} rooms, ${members.length} members');
      return;
    }

    final houseRes = await _client
        .from('houses')
        .select('created_at')
        .eq('id', houseId)
        .single();
    final houseCreatedAt = DateTime.parse(houseRes['created_at'] as String);

    final fromStr = _dateStr(from);
    final toStr = _dateStr(to);

    final existing = await _client
        .from('assignments')
        .select('room_id, assigned_date')
        .eq('house_id', houseId)
        .gte('assigned_date', fromStr)
        .lte('assigned_date', toStr);

    final existingSet = existing
        .map((e) => '${e['room_id']}|${e['assigned_date']}')
        .toSet();

    final batch = <Map<String, dynamic>>[];

    var current = from;
    while (!current.isAfter(to)) {
      final dateStr = _dateStr(current);
      final dayOffset = current.difference(houseCreatedAt).inDays;

      for (var ri = 0; ri < rooms.length; ri++) {
        final roomId = rooms[ri]['id'] as String;
        final key = '$roomId|$dateStr';

        if (!existingSet.contains(key)) {
          final memberIndex = (ri + dayOffset) % members.length;
          final memberId = members[memberIndex]['id'] as String;

          batch.add({
            'house_id': houseId,
            'room_id': roomId,
            'assigned_to': memberId,
            'assigned_date': dateStr,
          });
        }
      }

      current = current.add(const Duration(days: 1));
    }

    if (batch.isNotEmpty) {
      Log.i('ScheduleRepo', 'generated ${batch.length} new assignments');

      final inserted = await _client
          .from('assignments')
          .insert(batch)
          .select('id, room_id');

      // Fetch all checklist items for all rooms
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

      final progressBatch = <Map<String, dynamic>>[];
      for (final assignment in inserted) {
        final aid = assignment['id'] as String;
        final rid = assignment['room_id'] as String;
        for (final item in itemsByRoom[rid] ?? []) {
          progressBatch.add({
            'assignment_id': aid,
            'checklist_item_id': item['id'] as String,
            'is_completed': false,
          });
        }
      }

      if (progressBatch.isNotEmpty) {
        Log.i('ScheduleRepo', 'generated ${progressBatch.length} checklist progress entries');
        await _client.from('assignment_checklist_progress').insert(progressBatch);
      }
    } else {
      Log.d('ScheduleRepo', 'all assignments already exist');
    }
  }

  String _dateStr(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<ScheduleEntry> _mapEntries(List<dynamic> rows) {
    return rows.map((json) {
      final roomName = json['rooms'] is Map
          ? (json['rooms'] as Map)['name'] as String? ?? 'Unknown'
          : 'Unknown';
      final userName = json['profiles'] is Map
          ? ((json['profiles'] as Map)['nickname'] as String?) ?? ((json['profiles'] as Map)['name'] as String? ?? 'Unknown').split(' ').first
          : 'Unknown';
      return ScheduleEntry(
        id: json['id'] as String,
        date: DateTime.parse(json['assigned_date'] as String),
        roomName: roomName,
        assignedUser: userName,
        assignedTo: json['assigned_to'] as String,
        status: _statusFromDb(json['status'] as String),
      );
    }).toList();
  }

  ScheduleStatus _statusFromDb(String status) {
    switch (status) {
      case 'completed':
        return ScheduleStatus.completed;
      case 'missed':
        return ScheduleStatus.missed;
      default:
        return ScheduleStatus.pending;
    }
  }

  @override
  Future<List<ScheduleEntry>> getTodaySchedule() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final today = DateTime.now();
      final dateStr = _dateStr(today);

      final response = await _client
          .from('assignments')
          .select('id, assigned_to, assigned_date, status, rooms(name), profiles(name, nickname)')
          .eq('house_id', houseId)
          .eq('assigned_date', dateStr);

      return _mapEntries(response);
    } catch (e) {
      Log.e('ScheduleRepo', 'getTodaySchedule failed', e);
      rethrow;
    }
  }

  @override
  Future<List<ScheduleEntry>> getWeeklySchedule() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final today = DateTime.now();
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final startStr = _dateStr(weekStart);
      final endStr = _dateStr(weekEnd);

      final response = await _client
          .from('assignments')
          .select('id, assigned_to, assigned_date, status, rooms(name), profiles(name, nickname)')
          .eq('house_id', houseId)
          .gte('assigned_date', startStr)
          .lte('assigned_date', endStr)
          .order('assigned_date');

      return _mapEntries(response);
    } catch (e) {
      Log.e('ScheduleRepo', 'getWeeklySchedule failed', e);
      rethrow;
    }
  }

  @override
  Future<List<ScheduleEntry>> getMonthlySchedule() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final today = DateTime.now();
      final monthStart = DateTime(today.year, today.month, 1);
      final monthEnd = DateTime(today.year, today.month + 1, 0);

      final startStr = _dateStr(monthStart);
      final endStr = _dateStr(monthEnd);

      final response = await _client
          .from('assignments')
          .select('id, assigned_to, assigned_date, status, rooms(name), profiles(name, nickname)')
          .eq('house_id', houseId)
          .gte('assigned_date', startStr)
          .lte('assigned_date', endStr)
          .order('assigned_date');

      return _mapEntries(response);
    } catch (e) {
      Log.e('ScheduleRepo', 'getMonthlySchedule failed', e);
      rethrow;
    }
  }

  @override
  Future<List<UpcomingTask>> getUpcomingTasks() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) return [];

      final today = DateTime.now();
      final weekEnd = today.add(const Duration(days: 7));

      final todayStr = _dateStr(today);
      final endStr = _dateStr(weekEnd);

      final response = await _client
          .from('assignments')
          .select('''
            id, assigned_date, status,
            rooms(name),
            profiles(name, nickname),
            assignment_checklist_progress(is_completed, checklist_items(id))
          ''')
          .eq('house_id', houseId)
          .gte('assigned_date', todayStr)
          .lte('assigned_date', endStr)
          .order('assigned_date');

      final dayNames = ['', 'MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

      return response.map((json) {
        final date = DateTime.parse(json['assigned_date'] as String);
        final roomName = json['rooms'] is Map
            ? (json['rooms'] as Map)['name'] as String? ?? 'Unknown'
            : 'Unknown';
        final userName = json['profiles'] is Map
            ? ((json['profiles'] as Map)['nickname'] as String?) ?? ((json['profiles'] as Map)['name'] as String? ?? 'Unknown').split(' ').first
            : 'Unknown';

        final progressData = json['assignment_checklist_progress'] as List<dynamic>? ?? [];
        final totalItems = progressData.length;
        final completedItems = progressData.where((p) => p['is_completed'] == true).length;

        return UpcomingTask(
          id: json['id'] as String,
          dayLabel: dayNames[date.weekday],
          dateLabel: '${date.day}',
          areaName: roomName,
          assignedUser: userName,
          completedItems: completedItems,
          totalItems: totalItems,
        );
      }).toList();
    } catch (e) {
      Log.e('ScheduleRepo', 'getUpcomingTasks failed', e);
      rethrow;
    }
  }

  @override
  Future<void> initSchedule() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final profile = await _client
          .from('profiles')
          .select('house_id')
          .eq('id', userId)
          .maybeSingle();
      final houseId = profile?['house_id'] as String?;
      if (houseId == null) return;

      final today = DateTime.now();
      final endDate = today.add(const Duration(days: 30));
      await _generateRotations(houseId, today, endDate);
    } catch (e) {
      Log.e('ScheduleRepo', 'initSchedule failed', e);
      rethrow;
    }
  }
}
