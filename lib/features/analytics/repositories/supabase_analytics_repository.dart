import 'package:nesta/core/services/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analytics_data.dart';
import 'analytics_repository.dart';

class SupabaseAnalyticsRepository implements IAnalyticsRepository {
  final SupabaseClient _client;

  SupabaseAnalyticsRepository(this._client);

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

  @override
  Future<AnalyticsData> getAnalytics() async {
    try {
      final houseId = await _getHouseId();
      if (houseId == null) {
        return _emptyData();
      }

      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = DateTime(now.year, now.month + 1, 0);
      final startStr = monthStart.toIso8601String().substring(0, 10);
      final endStr = monthEnd.toIso8601String().substring(0, 10);

      // Monthly assignments
      final monthAssignments = await _client
          .from('assignments')
          .select('status, assigned_to, rooms(id, name)')
          .eq('house_id', houseId)
          .gte('assigned_date', startStr)
          .lte('assigned_date', endStr);

      final totalTasks = monthAssignments.length;
      final completedTasks = monthAssignments
          .where((a) => a['status'] == 'completed')
          .length;
      final completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

      // Most active member
      final userTaskCounts = <String, int>{};
      final userNames = <String, String>{};
      for (final a in monthAssignments) {
        final userId = a['assigned_to'] as String;
        userTaskCounts[userId] = (userTaskCounts[userId] ?? 0) + 1;
        final roomData = a['rooms'] as Map;
        if (!userNames.containsKey(userId)) {
          userNames[userId] = roomData['name'] as String? ?? 'Unknown';
        }
      }

      // Actually get user names from the assignment data
      // We need to join with profiles to get names
      final profiles = await _client
          .from('profiles')
          .select('id, name, nickname')
          .eq('house_id', houseId);

      final nameMap = {for (final p in profiles) p['id'] as String: (p['nickname'] as String?) ?? (p['name'] as String? ?? 'Unknown').split(' ').first};

      String mostActiveMember = '-';
      int activeMemberTaskCount = 0;
      for (final entry in userTaskCounts.entries) {
        if (entry.value > activeMemberTaskCount) {
          activeMemberTaskCount = entry.value;
          mostActiveMember = nameMap[entry.key] ?? entry.key;
        }
      }

      // Most missed room
      final roomMissCounts = <String, int>{};
      for (final a in monthAssignments) {
        if (a['status'] == 'missed') {
          final roomData = a['rooms'] as Map;
          final roomName = roomData['name'] as String? ?? 'Unknown';
          roomMissCounts[roomName] = (roomMissCounts[roomName] ?? 0) + 1;
        }
      }

      String mostMissedRoom = '-';
      int missedTaskCount = 0;
      for (final entry in roomMissCounts.entries) {
        if (entry.value > missedTaskCount) {
          missedTaskCount = entry.value;
          mostMissedRoom = entry.key;
        }
      }

      // Monthly fines
      final fines = await _client
          .from('fines')
          .select('amount')
          .eq('house_id', houseId)
          .gte('created_at', monthStart.toIso8601String())
          .lte('created_at', monthEnd.toIso8601String());

      final monthlyFines = fines.fold<int>(0, (sum, f) => sum + (f['amount'] as int));

      // Room scores
      final roomScores = <RoomScore>[];
      final roomTaskCounts = <String, int>{};
      final roomCompletedCounts = <String, int>{};

      for (final a in monthAssignments) {
        final roomData = a['rooms'] as Map;
        final roomName = roomData['name'] as String? ?? 'Unknown';
        roomTaskCounts[roomName] = (roomTaskCounts[roomName] ?? 0) + 1;
        if (a['status'] == 'completed') {
          roomCompletedCounts[roomName] = (roomCompletedCounts[roomName] ?? 0) + 1;
        }
      }

      for (final entry in roomTaskCounts.entries) {
        roomScores.add(RoomScore(
          roomName: entry.key,
          score: entry.value > 0
              ? (roomCompletedCounts[entry.key] ?? 0) / entry.value
              : 0.0,
        ));
      }

      return AnalyticsData(
        completionRate: completionRate,
        mostActiveMember: mostActiveMember,
        activeMemberTaskCount: activeMemberTaskCount,
        mostMissedRoom: mostMissedRoom,
        missedTaskCount: missedTaskCount,
        monthlyFines: monthlyFines,
        roomScores: roomScores,
      );
    } catch (e) {
      Log.e('AnalyticsRepo', 'getAnalytics failed', e);
      rethrow;
    }
  }

  AnalyticsData _emptyData() {
    return const AnalyticsData(
      completionRate: 0,
      mostActiveMember: '-',
      activeMemberTaskCount: 0,
      mostMissedRoom: '-',
      missedTaskCount: 0,
      monthlyFines: 0,
      roomScores: [],
    );
  }
}
